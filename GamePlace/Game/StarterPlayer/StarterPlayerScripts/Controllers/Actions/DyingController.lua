local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Knit = require(game.ReplicatedStorage.Packages.Knit)

local DyingController = Knit.CreateController({
	Name = "DyingController",
})

function DyingController.CreateViewport()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	character.Archivable = true

	local newChar = character:Clone()
	do
		for _, child: BasePart in ipairs(newChar:GetChildren()) do
			if child:IsA("BasePart") then
				child.Anchored = true
			end
		end
	end

	local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
	screenGui.Name = "DyingViewport"

	screenGui.IgnoreGuiInset = true

	local viewport = Instance.new("ViewportFrame", screenGui)
	viewport.Size = UDim2.fromScale(1, 1)
	viewport.BackgroundTransparency = 1
	viewport.Ambient = Color3.new(1, 1, 1)
	viewport.LightColor = Color3.new(1, 1, 1)

	viewport.CurrentCamera = workspace.CurrentCamera

	local blur = Instance.new("BlurEffect", viewport)
	blur.Size = 6
	blur.Enabled = true

	local worldModel = Instance.new("WorldModel", viewport)
	newChar.Parent = worldModel

	for _, value: BasePart in newChar:GetDescendants() do
		if value:IsA("LocalScript") then
			value = value :: LocalScript

			value.Enabled = false
		end

		if value:IsA("BasePart") then
			if value.Transparency == 1 then
				continue
			end
			value.Material = Enum.Material.Neon
			value.Transparency = 0.5
			value.Color = Color3.fromRGB(255, 255, 255)
		end
	end

	local speedPerSecond = 0.8
	local transparencyRemover = 0.15

	local y, x, z = newChar:GetPivot():ToEulerAnglesYXZ()
	local position = CFrame.new(newChar:GetPivot().Position + Vector3.new(0, 8, 0)) * CFrame.fromEulerAnglesYXZ(y, x, z)

	RunService:BindToRenderStep("FlyingViewport", Enum.RenderPriority.Last.Value, function(dt: number)
		newChar:PivotTo(newChar:GetPivot():Lerp(position, speedPerSecond * dt))

		for _, value: BasePart in newChar:GetDescendants() do
			if value:IsA("BasePart") then
				if value.Transparency == 1 then
					continue
				end
				local dif = transparencyRemover * dt
				value.Transparency = value.Transparency + dif
			end
		end
	end)

	task.delay(4, function()
		RunService:UnbindFromRenderStep("FlyingViewport")
		newChar:Destroy()
		screenGui:Destroy()
	end)
end
function DyingController.ShowInScreen()
	local playerGui = game.Players.LocalPlayer.PlayerGui
	local dyingGui = playerGui:FindFirstChild("DyingGui")

	if dyingGui then
		dyingGui.Enabled = true

		local background = dyingGui:FindFirstChild("Background")

		for _, g in background:GetDescendants() do
			if g:IsA("TextLabel") then
				g.TextTransparency = 1
			end
			if g:IsA("TextButton") then
				g.BackgroundTransparency = 1
			end
			if g:IsA("UIStroke") then
				g.Transparency = 1
			end
		end

		for _, g in background:GetDescendants() do
			if g:IsA("TextLabel") then
				TweenService:Create(
					g,
					TweenInfo.new(2, Enum.EasingStyle.Circular, Enum.EasingDirection.In, 0, false, 0),
					{ TextTransparency = 0 }
				):Play()
			end
			if g:IsA("TextButton") then
				TweenService:Create(
					g,
					TweenInfo.new(2, Enum.EasingStyle.Circular, Enum.EasingDirection.In, 0, false, 0),
					{ BackgroundTransparency = 0 }
				):Play()
			end
			if g:IsA("UIStroke") then
				TweenService:Create(
					g,
					TweenInfo.new(2, Enum.EasingStyle.Circular, Enum.EasingDirection.In, 0, false, 0),
					{ Transparency = 0 }
				):Play()
			end
		end
	else
		warn("DyingGui not found")
	end
end

function DyingController.OnDie()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local root = humanoid.RootPart
	local head: BasePart = character:WaitForChild("Head")

	game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable

	do
		local ratePerSecond = 0.65
		local fovPerSecond = 15

		RunService:BindToRenderStep("DyingController", Enum.RenderPriority.Last.Value, function(deltaTime: number)
			local cameraPosition =
				CFrame.lookAt(root.CFrame.Position + Vector3.new(0, 12, 0), head.CFrame.Position, Vector3.new(1, 1, 1))

			game.Workspace.CurrentCamera.FieldOfView =
				math.clamp(game.Workspace.CurrentCamera.FieldOfView + (fovPerSecond * deltaTime), 70, 90)
			game.Workspace.CurrentCamera.CFrame =
				game.Workspace.CurrentCamera.CFrame:Lerp(cameraPosition, ratePerSecond * deltaTime)

			game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
			game.Workspace.CurrentCamera.CameraSubject = root
		end)

		task.delay(3, function()
			DyingController.CreateViewport()
			DyingController.ShowInScreen()
		end)

		local healthConnection
		local respawnConnection

		local onRespawn = function()
			healthConnection:Disconnect()
			respawnConnection:Disconnect()

			RunService:UnbindFromRenderStep("DyingController")

			game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		end

		healthConnection = humanoid.HealthChanged:Once(onRespawn)
		respawnConnection = player.CharacterAdded:Once(onRespawn)
	end
end

function DyingController.Start()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	do --> create bind
		humanoid.Died:Connect(DyingController.OnDie)

		local function onCharacterAdded(newCharacter)
			character = newCharacter
			humanoid = character:WaitForChild("Humanoid")
			humanoid.Died:Connect(DyingController.OnDie)
		end

		player.CharacterAdded:Connect(onCharacterAdded)
	end
end

function DyingController.KnitInit()
	DyingController.Start()
end

return DyingController
