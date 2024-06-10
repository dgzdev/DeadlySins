local knit = require(game.ReplicatedStorage.Packages.Knit)

local EquipService = knit.CreateService({
	Name = "EquipService",
	Client = {},
})

function EquipService:GetEquippedTool(Character: Model)
	return Character:FindFirstChildWhichIsA("Tool")
end

function EquipService:EquipItem(Player: Player)
	local Character
	if Player:IsA("Player") then
		Character = Player.Character
	elseif Player:IsA("Model") then
		Character = Player
	else
		return error("Invalid argument #1 to 'EquipItem' (Player expected, got " .. typeof(Player) .. ")")
	end

	local Tool = self:GetEquippedTool(Character)
	if not Tool then
		return
	end

	if Tool:FindFirstChild("ToolGrip", true) then
		Tool:FindFirstChild("ToolGrip", true):Destroy()
	end

	local exclude = { "RightHand", "LeftHand", "RootPart", "HumanoidRootPart", "Root" }

	for _, obj: BasePart in Character:GetDescendants() do
		if obj:IsA("BasePart") and not table.find(exclude, obj.Name) then
			obj.Transparency = 0
		end
	end

	for _, m6: Motor6D in Tool:GetDescendants() do
		if m6:IsA("Motor6D") then
			m6.Part0 = Character:FindFirstChild(m6.Name, true)
			m6.Part1 = m6.Parent

			if not m6:GetAttribute("NoGrip") then
				m6.C0 = Tool.Grip
			end

			if m6:GetAttribute("Hide") then
				for _, obj in Character:GetDescendants() do
					if obj:IsA("BasePart") and not table.find(exclude, obj.Name) then
						if obj.Name == m6.Name then
							obj.Transparency = 1
						end
					end
				end
			end
		end
	end
end

function EquipService:UnequipItem(Player)
	local Character
	if Player:IsA("Player") then
		Character = Player.Character
	elseif Player:IsA("Model") then
		Character = Player
	else
		return error("Invalid argument #1 to 'EquipItem' (Player expected, got " .. typeof(Player) .. ")")
	end

	local exclude = { "RightHand", "LeftHand", "RootPart", "HumanoidRootPart", "Root" }

	for _, obj: BasePart in Character:GetDescendants() do
		if obj:IsA("BasePart") and not table.find(exclude, obj.Name) then
			obj.Transparency = 0
		end
	end
end

return EquipService
