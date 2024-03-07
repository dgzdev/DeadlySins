local ReplicatedStorage = game:GetService("ReplicatedStorage")
export type Rank = "E" | "D" | "C" | "B" | "A" | "S"
export type SubRank = "I" | "II" | "III" | "IV" | "V"
export type World = "World 1" | "World 2"
export type WeaponType = "Sword" | "Bow" | "Staff"
export type ProfileData = {
	Slots: {
		[number]: PlayerSlot | string,
	},
	Selected_Slot: number,
}
export type PlayerSlot = {
	Character: {
		FaceAccessory: number,
		HairAccessory: number,
		BackAccessory: number,
		WaistAccessory: number,
		ShouldersAccessory: number,
		NeckAccessory: number,
		HatAccessory: number,
		Shirt: number,
		Pants: number,
		Colors: { number },
	},
	Location: string | "Character Creation",
	LastJoin: string,

	Data: SlotData,
}
export type SlotData = {
	Level: number,

	Experience: number,
	Mana: number,

	Gold: number,

	Equiped: {
		Weapon: string,
		Id: number,
	},
	Quests: {},
	Hotbar: { number },
	Inventory: Inventory,
	Skills: { [string]: {
		AchiveDate: number | nil,
		Level: number,
	} },
	PointsAvailable: number,
	Points: {
		Inteligence: number,
		Strength: number,
		Agility: number,
		Endurance: number,
	},
}
export type Inventory = {
	[string]: {
		AchiveDate: number,
		Rank: Rank,
		SubRank: SubRank,
		Id: number,
	},
}
local ProfileTemplate: ProfileData = {
	Slots = {
		[1] = {
			["Character"] = {
				["Shirt"] = {
					Id = 1,
					Color = "#ff0000",
				},
				["Pants"] = {
					Id = 1,
					Color = "#ff0000",
				},
				["Shoes"] = {
					Id = 1,
					Color = "#ff0000",
				},
				["Hair"] = {
					Id = 1,
					Color = "#ff0000",
				},
				["Colors"] = { 255, 204, 153 },
			},
			["Location"] = "Character Creation",
			["LastJoin"] = os.date("%x"),
			["Data"] = {
				["Level"] = 1,

				["Experience"] = 0,
				["Mana"] = 50,

				["Gold"] = 0,

				["Equiped"] = {
					["Weapon"] = "Melee",
					["Id"] = 1,
				},
				["Quests"] = {},
				["Hotbar"] = { 1, 4, 5, 6 },
				["Inventory"] = {
					["Melee"] = {
						AchiveDate = os.time(),
						Rank = "E",
						Id = 1,
					},
					["Starter Sword"] = {
						AchiveDate = os.time(),
						Rank = "E",
						Id = 2,
					},
					["Iron Starter Sword"] = {
						AchiveDate = os.time(),
						Rank = "E",
						Id = 3,
					},
					["Luxury Sword"] = {
						AchiveDate = os.time(),
						Rank = "D",
						Id = 4,
					},
					["King's Longsword"] = {
						AchiveDate = os.time(),
						Rank = "S",
						Id = 5,
					},
					["TestDagger"] = {
						AchiveDate = os.time(),
						Rank = "E",
						Id = 6,
					},
				},
				["Skills"] = {
					["Inteligence"] = {
						["AchiveDate"] = os.time(),
						["Level"] = 1,
					},
					["Strength"] = {
						["AchiveDate"] = os.time(),
						["Level"] = 1,
					},
					["Agility"] = {
						["AchiveDate"] = os.time(),
						["Level"] = 1,
					},
					["Endurance"] = {
						["AchiveDate"] = os.time(),
						["Level"] = 1,
					},
				},
				["PointsAvailable"] = 0,
				["Points"] = {
					["Inteligence"] = 0,
					["Strength"] = 0,
					["Agility"] = 0,
					["Endurance"] = 0,
				},
			},
		},
		[2] = "false",
		[3] = "false",
		[4] = "false",
	},
	Selected_Slot = 1,
}

local function CreateHumanoidDescription(desc: { [string]: any }): HumanoidDescription
	local hd = Instance.new("HumanoidDescription")

	for index, value in pairs(desc) do
		hd[index] = value
	end
	return hd
end

return {
	profileKey = "DEVELOPMENT_6",
	profileTemplate = ProfileTemplate,
	defaultInventory = {
		["Melee"] = {
			AchiveDate = os.time(),
			Rank = "E",
			Id = 1,
		},
		["Starter Sword"] = {
			AchiveDate = os.time(),
			Rank = "E",
			Id = 2,
		},
		["Iron Starter Sword"] = {
			AchiveDate = os.time(),
			Rank = "E",
			Id = 3,
		},
		["Luxury Sword"] = {
			AchiveDate = os.time(),
			Rank = "D",
			Id = 4,
		},
		["King's Longsword"] = {
			AchiveDate = os.time(),
			Rank = "S",
			Id = 5,
		},
		["TestDagger"] = {
			AchiveDate = os.time(),
			Rank = "E",
			Id = 6,
		},
	},
	gameWeapons = {
		["Melee"] = {
			Type = "Melee",
			Damage = 5,
		},
		["Starter Sword"] = {
			Type = "Sword",
			Damage = 10,
			Rarity = "E", --| "D" | "C" | "B" | "A" | "S"
			SubRarity = "I", --| "II" | "III" | "IV" | "V"
		},
		["Iron Starter Sword"] = {
			Type = "Sword",
			Damage = 20,
			Rarity = "E",
			SubRarity = "II", -- "II" | "III" | "IV" | "V"
		},
		["Luxury Sword"] = {
			Type = "Sword",
			Damage = 30,
			Rarity = "D",
			SubRarity = "I", -- "II" | "III" | "IV" | "V"
		},
		["King's Longsword"] = {
			Type = "Sword",
			Damage = 50,
			Rarity = "S",
			SubRarity = "I", -- "II" | "III" | "IV" | "V"
		},
		["TestDagger"] = {
			Type = "Dagger",
			Damage = 5,
			Rarity = "E",
			SubRarity = "I", -- "II" | "III" | "IV" | "V"
		},
	},
	newbieBadge = 2066631008828576,
	gameEnemies = {
		["Teste"] = {
			Health = 10000,
			Damage = 1,
			Speed = 1,
			Inteligence = 1,
			Experience = 100,
			AttackType = "Melee",
			Gold = 100,
			Drops = {
				["Iron Starter Sword"] = 15,
			},
		},
		["Goblin"] = {
			Health = 50,
			Damage = 5,
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
			Health = 100,
			Damage = 10,
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
			Health = 150,
			Speed = 9,
			Damage = 15,
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
	gameQuests = {
		["Kill Goblins"] = {
			Type = "Kill Enemies",
			EnemyName = "Goblin",
			Amount = 1,
			Rewards = {
				Experience = 100,
			},
		},
	},
	questPrompts = {
		["Kill Goblins"] = {
			Title = "Defeat Goblins!",
			Description = "Defeat 5 Goblins and return to me for a reward!",
		},
	},
	npcQuests = {
		["Sung Jin-Woo"] = "Kill Goblins",
	},
	gameDialogs = {

		["Sung Jin-Woo"] = {
			"It seems every battle pushes me to a new limit... But I feel there's so much more I can achieve. I just hope I'm ready for whatever comes next.",
			"Stay strong, Our paths will cross again in the battles to come.",
		},

		["Cha Hae-In"] = {
			"I always thought I knew what strength was... But seeing you grow and face challenges, made me question what it truly means to be powerful.",
			"Farewell, May your courage always be as sharp as your sword.",
		},

		["Go Gun-Hee"] = {
			"Your journey has been remarkable. It's rare to see someone with so much potential. Remember, the Hunter Association will always have your back.",
			"Goodbye, Remember, the strength of a hunter lies not only in power but in heart.",
		},

		["Ju Hee-Min"] = {
			"I knew there was something special about you from the start, Your determination and strength are truly inspiring. I'm eager to see how far you can go.",
			"See you soon, Keep pushing your limits.",
		},

		["Woo Jin-Cheol"] = {
			"I have to admit, I had my doubts about you, But you've proven me wrong time and again. It's an honor to fight alongside you.",
			"Until next time, Keep your guard up and your spirits high.",
		},
	},

	weaponSupport = {
		["Sword"] = {
			Model = ReplicatedStorage.Models.WeaponSupports.Sword,
			Position = CFrame.new(1.3, 1.1, 1) * CFrame.fromOrientation(math.rad(0), math.rad(-60), math.rad(-90)),
		},
	},
}
