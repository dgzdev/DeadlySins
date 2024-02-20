export type Rank = "E" | "D" | "C" | "B" | "A" | "S"
export type SubRank = "I" | "II" | "III" | "IV" | "V"
export type World = "World 1" | "World 2"
export type WeaponType = "Sword" | "Bow" | "Staff"
export type PlayerData = {
	rank: Rank,
	subRank: SubRank,

	Level: number,
	Experience: number,
	Gold: number,
	Equiped: string,

	Inventory: {
		[string]: {
			AchiveDate: number,
			Rank: Rank,
		},
	},
	Skills: { [string]: {
		AchiveDate: number | nil,
		Level: number,
	} },

	World: World,
	Points: {
		Inteligence: number,
		Strength: number,
		Agility: number,
		Endurance: number,
	},
}

local ProfileTemplate: PlayerData = {
	rank = "E",
	subRank = "I",

	Equiped = "Wooden_Sword",

	Level = 1,
	Experience = 0,
	Gold = 0,

	Inventory = {},
	Skills = {},

	World = "World 1",

	Points = {
		Inteligence = 1,
		Strength = 1,
		Agility = 1,
		Endurance = 1,
	},
}

local function CreateHumanoidDescription(desc: HumanoidDescription): HumanoidDescription
	local hd = Instance.new("HumanoidDescription")

	for index, value in pairs(desc) do
		hd[index] = value
	end
	return hd
end

return {
	profileKey = "PLAYER_DATA",
	profileTemplate = ProfileTemplate,
	defaultInventory = {
		["Wooden_Sword"] = {
			AchiveDate = os.time(),
			Rank = "E",
		},
	},
	gameWeapons = {
		["Wooden_Sword"] = {
			Type = "Sword",
			Damage = 10,
		},
	},
	gameEnemies = {
		["Teste"] = {
			Health = 50,
			Damage = 1,
			Speed = 1,
			Inteligence = 1,
			Experience = 10,
			AttackType = "Melee",
			Gold = 10,
		},
		["Goblin"] = {
			Health = 100,
			Damage = 10,
			Experience = 10,
			Speed = 18,
			AttackType = "Melee",
			Inteligence = 5,
			HumanoidDescription = CreateHumanoidDescription({
				Shirt = 10251245552,
				Pants = 240444745,
				FaceAccessory = 13688367892,
				Face = 0,

				HeadColor = Color3.new(0.411764, 0.6, 0.290196),
				TorsoColor = Color3.new(0.411764, 0.6, 0.290196),
				LeftArmColor = Color3.new(0.411764, 0.6, 0.290196),
				RightArmColor = Color3.new(0.411764, 0.6, 0.290196),
				LeftLegColor = Color3.new(0.411764, 0.6, 0.290196),
				RightLegColor = Color3.new(0.411764, 0.6, 0.290196),
			}),
			Gold = 10,
		},
		["Orc"] = {
			Health = 200,
			Damage = 20,
			Experience = 20,
			Speed = 12,
			Inteligence = 4,
			AttackType = "Melee",
			HumanoidDescription = CreateHumanoidDescription({
				Shirt = 6326000551,
				Pants = 6326002102,
				FaceAccessory = 11039855614,

				HeadColor = Color3.fromRGB(69, 75, 36),
				TorsoColor = Color3.fromRGB(69, 75, 36),
				LeftArmColor = Color3.fromRGB(69, 75, 36),
				RightArmColor = Color3.fromRGB(69, 75, 36),
				LeftLegColor = Color3.fromRGB(69, 75, 36),
				RightLegColor = Color3.fromRGB(69, 75, 36),
			}),
			Gold = 20,
		},
		["Troll"] = {
			Health = 300,
			Speed = 9,
			Damage = 30,
			Experience = 30,
			Inteligence = 3,
			AttackType = "Melee",
			HumanoidDescription = CreateHumanoidDescription({
				Pants = 564303086,
				FaceAccessory = 12403324965,
				HatAccessory = 12922312435,

				HeadColor = Color3.fromRGB(61, 36, 75),
				TorsoColor = Color3.fromRGB(61, 36, 75),
				LeftArmColor = Color3.fromRGB(61, 36, 75),
				RightArmColor = Color3.fromRGB(61, 36, 75),
				LeftLegColor = Color3.fromRGB(61, 36, 75),
				RightLegColor = Color3.fromRGB(61, 36, 75),
			}),
			Gold = 30,
		},
	},
}
