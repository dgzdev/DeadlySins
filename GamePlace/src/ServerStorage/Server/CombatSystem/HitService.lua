local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local HitService = {}

function HitService:getMass(model)
	assert(model and model:IsA("Model"), "Model argument of getMass must be a model.")
	local mass = 0
	for i, v in pairs(model:GetDescendants()) do
		if v:IsA("BasePart") then
			mass += v:GetMass()
		end
	end
	return mass
end

function HitService:Hit(
	exec: Humanoid,
	hum: Humanoid,
	dmg: number,
	stun: boolean,
	kb: Vector3,
	effect: (hum: Humanoid) -> {} | nil
)
	local execChar = exec:FindFirstAncestorWhichIsA("Model")
	local tarChar = hum:FindFirstAncestorWhichIsA("Model")
	if execChar:GetAttribute("Defending") then
		return
	end
	if execChar:GetAttribute("Invincible") then
		return
	end
	if hum:GetAttribute("Invincible") then
		return
	end

	local isStunned = tarChar:GetAttribute("Stun")

	if dmg then
		if isStunned then
			dmg *= 2
		end
		hum:TakeDamage(dmg)
	end

	if kb then
		hum.RootPart.AssemblyAngularVelocity = Vector3.new()
		hum.RootPart.AssemblyLinearVelocity = Vector3.new()

		hum.RootPart.AssemblyLinearVelocity = (kb * self:getMass(tarChar))
	end

	if effect then
		effect(hum)
	end

	if hum.Health <= 0 then
		local Death = SoundService:WaitForChild("SFX"):WaitForChild("Death")
		local death = Death:Clone()

		local Part = Instance.new("Part")
		Part.Size = Vector3.new(1, 1, 1)
		Part.CFrame = hum.RootPart.CFrame
		Part.Anchored = true
		Part.CanCollide = false
		Part.Transparency = 1
		Part.Parent = Workspace.Others

		death.RollOffMinDistance = 0
		death.RollOffMaxDistance = 40
		death.RollOffMode = Enum.RollOffMode.Linear

		death.Parent = Part

		death:Play()
		Debris:AddItem(death, death.TimeLength + 0.1)
		Debris:AddItem(Part, death.TimeLength + 0.1)
	end
end

return HitService