local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local GameData = require(ServerStorage.GameData)

local PlayerService

local SkillTreeService = Knit.CreateService({
	Name = "SkillTreeService",
	Client = {
		UnlockedNewSkill = Knit.CreateSignal(),
	},
})

function SkillTreeService:GetAllSkills()
	local SkillsInTree = GameData.gameSkillsTree

	return SkillsInTree
end

function SkillTreeService:FindSkillInTree(SkillName)
	local SkillTree = self:GetAllSkills()

	local function FindSpecificSkill(InitialNode): GameData.TreeNode
		for name, skillInfo: GameData.TreeNode in pairs(InitialNode) do
			if skillInfo.Name == SkillName then
				return skillInfo
			end
		end
	end
end

function SkillTreeService:GetAvailableSkillsToUnlock(Player)
	local PlayerData: GameData.SlotData = PlayerService:GetData(Player)
	local SkillsTreeUnlocked = PlayerData.SkillsTreeUnlocked
	local SkillTree = self:GetAllSkills()
	local ToUnlock = {}

	local function ReadTree(node)
		if not node then
			return
		end
		for name, skillInfo: GameData.TreeNode in pairs(node) do
			if skillInfo.Pendencies == nil then
				table.insert(ToUnlock, skillInfo.Name)
				ReadTree(skillInfo.branches)
				break
			end

			if skillInfo.Pendencies == "table" then
				for _, PendencyName in pairs(skillInfo.Pendencies) do
					if not SkillsTreeUnlocked[skillInfo.Pendencies] then
						break
					end
					table.insert(ToUnlock, PendencyName)
					ReadTree(node.branches)
				end
			end

			if not skillInfo.branches then
				continue
			end

			if not SkillsTreeUnlocked[skillInfo.Pendencies] then
				break
			end

			table.insert(ToUnlock, skillInfo.Name)
			ReadTree(skillInfo.branches)
		end
	end
	ReadTree(SkillTree)

	return ToUnlock
end

function SkillTreeService.KnitStart()
	PlayerService = Knit.GetService("PlayerService")
end

return SkillTreeService
