local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Knit = require(game.ReplicatedStorage.Packages.Knit)

local CameraModule = Knit.CreateController({
	Name = "CameraController",
})

CameraModule.OTS = require(ReplicatedStorage.Modules.OTS) --> OTS is a module for camera manipulation.

local CameraEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CAMERA")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- if not (game:IsLoaded()) then
-- 	game.Loaded:Wait()
-- end

-- if playerGui:FindFirstChild("loadingScreen") then
-- 	playerGui:FindFirstChild("loadingScreen").Destroying:Wait()
-- end

local ScrollLimits = {
	["Min"] = 2,
	["Max"] = 25,
}

function CameraModule:Init()
	character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:WaitForChild("Humanoid")

	-- ? Check if the OTS module is loaded.
	self:CheckCondition(self.OTS ~= nil, "[CameraModule] OTS is nil, this is a problem.")

	if ReplicatedStorage:GetAttribute("FirstTimeAnimationEnd") then
		self:EnableCamera()
	end

	player.CharacterAdded:Connect(function()
		humanoid = character:WaitForChild("Humanoid")
		character = player.Character or player.CharacterAdded:Wait()
		self:EnableCamera()
	end)

	humanoid.Died:Once(function()
		CameraModule.OTS:SetMouseStep(false)
		self:DisableCamera()
	end)
end
function CameraModule:CheckCondition(condition: boolean, message: string) --> Check if a condition is true, if not, throw an error.
	if condition == false then
		error(message)
	end
end

local function LockOnTarget(target: Model)
	if not target then
		return "broke"
	end

	local Camera = Workspace.CurrentCamera

	local root = character.PrimaryPart
	if not root then
		return "broke"
	end

	if not target:IsDescendantOf(Workspace) then
		return "broke"
	end

	local cameraPosition = root.CFrame * CFrame.new(2.5, 2, 7.5)
	local targetCFrame = CFrame.lookAt(cameraPosition.Position, target:GetPivot().Position, root.CFrame.UpVector)
	Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 0.5)
end

local CurrentCamera = "OTS"
function CameraModule.ToggleCameras(action: string, inputState: Enum.UserInputState, inputObject: any)
	if inputState ~= Enum.UserInputState.Begin then
		return
	end

	if CurrentCamera == "OTS" then
		local mouse = player:GetMouse()
		local hit = mouse.Target
		if not hit then
			return
		end

		if hit:IsDescendantOf(character) then
			return
		end

		if hit:IsDescendantOf(Workspace.NPC) then
			return
		end

		local model = hit:FindFirstAncestorWhichIsA("Model")
		if not model then
			return
		end

		local hm = model:FindFirstChildWhichIsA("Humanoid")
		if not hm then
			return
		end

		hm.Died:Once(function()
			CameraModule.ToggleCameras("toggle", Enum.UserInputState.Begin, Enum.KeyCode.CapsLock)
		end)
		model.Destroying:Once(function()
			CameraModule.ToggleCameras("toggle", Enum.UserInputState.Begin, Enum.KeyCode.CapsLock)
		end)

		workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable

		RunService:BindToRenderStep("LockOn", Enum.RenderPriority.Camera.Value, function()
			local r = LockOnTarget(model)
			if r == "broke" then
				CameraModule.ToggleCameras("toggle", Enum.UserInputState.Begin, Enum.KeyCode.CapsLock)
			end
		end)

		CurrentCamera = "LOCKON"

		CameraModule.OTS:Disable()

		UserInputService.MouseIconEnabled = false
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

		local LockOnHUD = game.ReplicatedStorage.Essentials.LockOnHUD:Clone()
		LockOnHUD.Parent = model
	elseif CurrentCamera == "LOCKON" then
		CurrentCamera = "OTS"

		RunService:UnbindFromRenderStep("LockOn")

		CameraModule.OTS:Enable()

		UserInputService.MouseIconEnabled = true
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

		if Workspace:FindFirstChild("LockOnHUD", true) then
			Workspace:FindFirstChild("LockOnHUD", true):Destroy()
		end
	end
end

ContextActionService:BindAction("ToggleCameras", CameraModule.ToggleCameras, false, Enum.KeyCode.CapsLock)

function CameraModule:EnableCamera()
	ContextActionService:BindAction("MouseWheel", function(actionName, inputState, inputObject)
		local CameraSettings = self.OTS.CameraSettings
		local SETTINGS = self.OTS.CameraSettings["DefaultShoulder"]
		if inputObject.Position.Z == 1 then
			--> MouseWheelUp
			SETTINGS.Offset -= Vector3.new(0, 0, 0.5)
		else
			--> MouseWheelDown
			SETTINGS.Offset += Vector3.new(0, 0, 0.5)
		end
		SETTINGS.Offset = Vector3.new(
			SETTINGS.Offset.X,
			SETTINGS.Offset.Y,
			math.clamp(SETTINGS.Offset.Z, ScrollLimits.Min, ScrollLimits.Max)
		)
	end, false, Enum.UserInputType.MouseWheel)

	if self.OTS.IsEnabled == false then
		self.OTS:Enable()
	end
end

function CameraModule:DisableCamera()
	if self.OTS.IsEnabled == true then
		self.OTS:Disable()
	end
end
CameraModule.OnProfileReceive = function(self) end --> Ignore, not used for this module.
CameraModule:Init()

CameraEvent.Event:Connect(function(action: string, ...)
	if action == "Enable" then
		if CurrentCamera == "LOCKON" then
			CameraModule.ToggleCameras("toggle", Enum.UserInputState.Begin, Enum.KeyCode.CapsLock)
		end
		CameraModule:EnableCamera()
	elseif action == "Disable" then
		if CurrentCamera == "LOCKON" then
			CameraModule.ToggleCameras("toggle", Enum.UserInputState.Begin, Enum.KeyCode.CapsLock)
		end
		CameraModule:DisableCamera()
	end

	if action == "Lock" then
		if CurrentCamera == "OTS" then
			CameraModule.OTS:SetMouseStep(true)
		elseif CurrentCamera == "LOCKON" then
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
			UserInputService.MouseIconEnabled = false
		end
	elseif action == "Unlock" then
		if CurrentCamera == "OTS" then
			CameraModule.OTS:SetMouseStep(false)
		elseif CurrentCamera == "LOCKON" then
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			UserInputService.MouseIconEnabled = true
		end
	end

	if action == "FOV" then
		local FOV = ...
		CameraModule.OTS.CameraSettings.DefaultShoulder.FieldOfView = FOV
	end
end)

return CameraModule