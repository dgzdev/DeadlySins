local Debris = game:GetService("Debris")
local Knit = require(game.ReplicatedStorage.Packages.Knit)
local Drop = {}

local TweenService = game:GetService("TweenService")
local VFX = require(game.ReplicatedStorage.Modules.VFX)
local SFX = require(game.ReplicatedStorage.Modules.SFX)

local RenderController
local ShakerController

local Player = game.Players.LocalPlayer

local Assets = game.ReplicatedStorage.VFX.LootDrops

local rarityValues = {
    ["S"] = 6,
    ["A"] = 5,
    ["B"] = 4,
    ["C"] = 3,
    ["D"] = 2,
    ["E"] = 1,
}

function Drop.LootDrop(RenderData)
    local Args = RenderData.arguments
    for i,v in pairs(Assets:GetChildren()) do
        if v:GetAttribute("Rank") == Args.HRank then
            print("a")
            local DropClone = v:Clone() :: Model
            local Prompt = Instance.new("ProximityPrompt", DropClone.PrimaryPart)
            Prompt:SetAttribute("Event", "CheckLoot")
            DropClone.Parent = workspace
            DropClone:MoveTo(Args.Offset)
        else
            print(Args)
        end
    end
end


function Drop.Start()
	RenderController = Knit.GetController("RenderController")
	ShakerController = Knit.GetController("ShakerController")
end

function Drop.Caller(RenderData)
	local Effect = RenderData.effect

	if Drop[Effect] then
		Drop[Effect](RenderData)
	else
		print("Effect not found")
	end
end


return Drop