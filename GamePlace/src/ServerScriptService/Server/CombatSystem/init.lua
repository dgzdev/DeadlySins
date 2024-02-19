local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

local PlayerManagers = require(script.Parent.Players)
local GameData = require(ServerStorage.GameData)
local RaycastHitbox = require(ReplicatedStorage.Modules.RaycastHitboxV4)

local CombatSystem = {}

local Combat = ReplicatedStorage.Events.Combat :: RemoteFunction

Combat.OnServerInvoke = function(player: Player)
	local PlayerManager = PlayerManagers:GetPlayerManager(player)
	if not PlayerManager then
		return
	end

	local Equiped = PlayerManager.Profile.Data.Equiped

	local InventoryData = GameData.gameWeapons[Equiped]
	local WeaponType = InventoryData.Type
	local Damage = InventoryData.Damage
	local Character = player.Character
	if not Character then
		return
	end

	local Weapon = Character:FindFirstChild(Equiped)
	if not Weapon then
		return
	end

	task.spawn(function()
		local Rayparams = RaycastParams.new()
		Rayparams.FilterType = Enum.RaycastFilterType.Blacklist
		Rayparams.FilterDescendantsInstances = { Character }
		Rayparams.IgnoreWater = true

		-- Attack logic
		local Hitbox = RaycastHitbox.new(Weapon)
		Hitbox.RaycastParams = Rayparams
		Hitbox.DebugLog = false
		Hitbox.Visualizer = true
		Hitbox.OnHit:Connect(function(hit, humanoid: Humanoid)
			if humanoid and (humanoid:IsDescendantOf(Workspace.Enemies)) then
				humanoid:TakeDamage(Damage)
				local Char = humanoid:FindFirstAncestorWhichIsA("Model")
				local Root = Char:FindFirstChild("HumanoidRootPart") :: BasePart

				local BodyVelocity = Instance.new("BodyVelocity")
				BodyVelocity.Velocity = (Root.CFrame.LookVector.Unit * -1) * 25
				BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				BodyVelocity.Parent = Root

				local sound = SoundService.Attack.Hit:Clone()
				sound.RollOffMinDistance = 0
				sound.RollOffMaxDistance = 50
				sound.RollOffMode = Enum.RollOffMode.Inverse
				sound.Parent = Root
				sound:Play()
				Debris:AddItem(sound, sound.TimeLength + 0.1)

				Debris:AddItem(BodyVelocity, 0.25)

				Hitbox:HitStop()
			end
		end)
		Hitbox:HitStart(1)
	end)

	return {
		Type = WeaponType,
	}
end

function CombatSystem:Equip(player: Player, item: string)
	local InventoryData = GameData.gameWeapons[item]
	local WeaponType = InventoryData.Type

	if WeaponType == "Sword" then
		local Model = ReplicatedStorage.Models.Swords
		local Sword = Model:FindFirstChild(item)
		if not Sword then
			return error("Sword not found.")
		end

		local PlayerManager = PlayerManagers:GetPlayerManager(player)
		local Character = player.Character or player.CharacterAdded:Wait()
		local Root = Character:WaitForChild("HumanoidRootPart")

		Root.Anchored = true

		local Position = "Right Arm"

		local SwordClone = Sword:Clone() :: Model
		SwordClone.Parent = Character

		local RightHand = Character:WaitForChild(Position)
		SwordClone:PivotTo(
			RightHand:GetPivot() * CFrame.new(0, -1, -1.9) * CFrame.Angles(0, math.rad(180), math.rad(90))
		)

		local Weld = Instance.new("WeldConstraint")
		Weld.Parent = SwordClone
		Weld.Part0 = RightHand
		Weld.Part1 = SwordClone.PrimaryPart

		PlayerManager.Profile:SetMetaTag("Equiped", item)

		Root.Anchored = false
	end
end

Players.PlayerAdded:Connect(function(player)
	repeat
		task.wait(1)
	until PlayerManagers:GetPlayerManager(player) ~= nil

	local Manager = PlayerManagers:GetPlayerManager(player)
	CombatSystem:Equip(player, Manager.Profile.Data.Equiped)
end)

return CombatSystem
