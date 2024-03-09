local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CameraModule = {}
CameraModule.OTS = require(ReplicatedStorage.Modules.OTS) --> OTS is a module for camera manipulation.

local CameraEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CAMERA")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

if not (game:IsLoaded()) then
	game.Loaded:Wait()
end

if playerGui:FindFirstChild("loadingScreen") then
	playerGui:FindFirstChild("loadingScreen").Destroying:Wait()
end

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

CameraModule.EnableCamera = function(self)
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

CameraModule.DisableCamera = function(self)
	if self.OTS.IsEnabled == true then
		self.OTS:Disable()
	end
end
CameraModule.OnProfileReceive = function(self) end --> Ignore, not used for this module.
CameraModule:Init()

CameraEvent.Event:Connect(function(action: string, ...)
	if action == "Enable" then
		CameraModule:EnableCamera()
	elseif action == "Disable" then
		CameraModule:DisableCamera()
	end

	if action == "Lock" then
		CameraModule.OTS:SetMouseStep(true)
	elseif action == "Unlock" then
		CameraModule.OTS:SetMouseStep(false)
	end

	if action == "FOV" then
		local FOV = ...
		CameraModule.OTS.CameraSettings.DefaultShoulder.FieldOfView = FOV
	end
end)

return CameraModule
