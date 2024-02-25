local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local CustomizationGui: ScreenGui = StarterGui:WaitForChild("CharacterCustomization"):Clone()
local PressAnyKey: ScreenGui = StarterGui:WaitForChild("PressAnyKey"):Clone()
local SlotSelection = StarterGui:WaitForChild("SlotSelection"):Clone()

CustomizationGui.Parent = PlayerGui

local title1: TextLabel = PressAnyKey:WaitForChild("title1")
local title2: TextLabel = PressAnyKey:WaitForChild("title2")
local pressanykey: TextLabel = PressAnyKey:WaitForChild("pressanykey")

require(script.Parent:WaitForChild("UI")):Init()

local hasPressedButton = false

local ViewPart: BasePart = Workspace:WaitForChild("CameraParts"):WaitForChild("View")

local CharacterPart: BasePart = Workspace:WaitForChild("CameraParts"):WaitForChild("Character")

local function SlideIn()
	local RightSide = SlotSelection:WaitForChild("RightSide")
	local LeftSide = SlotSelection:WaitForChild("LeftSide")
	local Mid = SlotSelection:WaitForChild("Mid")

	local OriginalPositions = {
		["R"] = UDim2.fromScale(RightSide.Position.X.Scale, RightSide.Position.Y.Scale),
		["L"] = UDim2.fromScale(LeftSide.Position.X.Scale, LeftSide.Position.Y.Scale),
		["M"] = UDim2.fromScale(Mid.Position.X.Scale, Mid.Position.Y.Scale),
	}

	RightSide.Position = UDim2.fromScale(1 + RightSide.Size.X.Scale, 0.5)
	LeftSide.Position = UDim2.fromScale(-LeftSide.Size.X.Scale, 0.5)
	Mid.Position = UDim2.fromScale(0.5, 1 + Mid.Size.Y.Scale)

	SlotSelection.Enabled = true

	local tweenInfo = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0.25)

	local tween = TweenService:Create(RightSide, tweenInfo, { Position = OriginalPositions.R })
	tween:Play()
	tween = TweenService:Create(LeftSide, tweenInfo, { Position = OriginalPositions.L })
	tween:Play()
	tween = TweenService:Create(Mid, tweenInfo, { Position = OriginalPositions.M })
	tween:Play()
end

local function fadeIn()
	local clouds = Workspace:WaitForChild("Map"):WaitForChild("clouds")
	task.spawn(function()
		for _, v: ParticleEmitter in ipairs(clouds:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				v:Emit(2500)
			end
		end
	end)

	local sound1 = SoundService:WaitForChild("Music"):WaitForChild("desolateSting")
	sound1.Ended:Once(function(soundId)
		SoundService:WaitForChild("Music"):WaitForChild("desolate"):Play()
	end)
	sound1:Play()

	local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 1)
	local tween = TweenService:Create(title1, tweenInfo, { TextTransparency = 0 })
	tween:Play()
	tween = TweenService:Create(title2, tweenInfo, { TextTransparency = 0 })
	tween:Play()
	tween = TweenService:Create(pressanykey, tweenInfo, { TextTransparency = 0 })
	tween:Play()
	tween.Completed:Wait()

	local infiniteTween = TweenInfo.new(1.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true, 0)
	tween = TweenService:Create(pressanykey, infiniteTween, { TextTransparency = 0.9 })
	tween:Play()
end

local function fadeOut()
	hasPressedButton = true

	SoundService:WaitForChild("SFX"):WaitForChild("button.wav"):Play()

	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0.25)
	local tween = TweenService:Create(title1, tweenInfo, { TextTransparency = 1 })
	tween:Play()

	local tween2 = TweenService:Create(title2, tweenInfo, { TextTransparency = 1 })
	tween2:Play()

	tween = TweenService:Create(pressanykey, tweenInfo, { TextTransparency = 1 })
	tween:Play()

	tween2.Completed:Wait()

	PressAnyKey.Enabled = false

	local TweenStyle = TweenInfo.new(3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0.8)
	local tw = TweenService:Create(Workspace.CurrentCamera, TweenStyle, {
		CFrame = CharacterPart.CFrame,
		FieldOfView = 90,
	})
	tw:Play()
	tw.Completed:Wait()

	SlideIn()
end

local function onInputBegan(input)
	if hasPressedButton then
		return
	end

	if input.UserInputType == Enum.UserInputType.Keyboard then
		fadeOut()
	elseif input.UserInputType == Enum.UserInputType.Touch then
		fadeOut()
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
		fadeOut()
	elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
		fadeOut()
	end
end

SlotSelection.Parent = PlayerGui
SlotSelection.Enabled = false

if not Players:GetAttribute("Loaded") then
	Players:GetAttributeChangedSignal("Loaded"):Wait()
end

CharacterPart.Anchored = true

task.wait()

local Camera = Workspace.CurrentCamera
Camera.CameraType = Enum.CameraType.Scriptable
Camera.CFrame = ViewPart.CFrame

PressAnyKey.Parent = PlayerGui

PressAnyKey.Enabled = true

UserInputService.InputBegan:Connect(onInputBegan)

title1.TextTransparency = 1
title2.TextTransparency = 1
pressanykey.TextTransparency = 1

fadeIn()