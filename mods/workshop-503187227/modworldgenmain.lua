local require = GLOBAL.require
require("map/lockandkey")
require("map/tasks")
require("map/rooms")
require("map/terrain")
require("map/level")

local blockersets = require("map/blockersets")

local LOCKS = GLOBAL.LOCKS
local KEYS = GLOBAL.KEYS
GLOBAL.SIZE_VARIATION = GetModConfigData("GlobalBiomeSize")
local GROUND = GLOBAL.GROUND
local LEVELTYPE = GLOBAL.LEVELTYPE

AddTaskSetPreInitAny(function(tasksetdata)
	print("**********************************************************")
	print("**********************************************************")
	print("************ TASK SET PRE INIT FOR FOREST !!! ************")
	print("**********************************************************")
	print("**********************************************************")
		if tasksetdata.location ~= "forest" then
			print("Bailing!")
			return
		end
	print("Applying!")

	tasksetdata.numoptionaltasks = GetModConfigData("RandomOptionalBiomes")

	tasksetdata.set_pieces["ResurrectionStone"] = { count = GetModConfigData("ResurrectionStoneOption"), tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Badlands"}}
	tasksetdata.set_pieces["WormholeGrass"] = { count = 8, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"}}
	tasksetdata.set_pieces["MooseNest"] = { count = GetModConfigData("MooseSpawn"), tasks={"Make a pick", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Make a Beehat", "Magic meadow", "Frogs and bugs"}}
	tasksetdata.set_pieces["DragonflyArena"] = { count = GetModConfigData("DragonflySpawn"), tasks={"Badlands"}} --Dragonfly Spawn Bas
	tasksetdata.set_pieces["CaveEntrance"] = { count = 10, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"}}
	-- Default Biomes Set Pieces
	tasksetdata.set_pieces["Farmplot"] = { count = GetModConfigData("FarmplotOption"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}}
	tasksetdata.set_pieces["StoneHenge"] = { count = GetModConfigData("StoneHengeOption"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}}
	tasksetdata.set_pieces["SimpleBase"] = { count = GetModConfigData("SimpleBaseOption"), tasks={"Dig that rock"}}
	tasksetdata.set_pieces["RuinedBase"] = { count = GetModConfigData("RuinedBaseOption"), tasks={"Dig that rock"}}
	tasksetdata.set_pieces["Grotto"] = { count = GetModConfigData("GrottoOption"), tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Badlands", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}}
	tasksetdata.set_pieces["LivingTree"] = { count = GetModConfigData("LivingTreeOption"), tasks={"Squeltch", "Forest hunters"}}
	tasksetdata.set_pieces["MacTuskTown"] = { count = GetModConfigData("MacTuskTownOption"), tasks={"Forest hunters", "Badlands"}}
	tasksetdata.set_pieces["MacTuskCity"] = { count = GetModConfigData("MacTuskCityOption"), tasks={"Forest hunters", "Badlands"}}
	tasksetdata.set_pieces["MaxMermShrine"] = { count = GetModConfigData("MermShrineOption"), tasks={"Squeltch"}}
	tasksetdata.set_pieces["MaxPigShrine"] = { count = GetModConfigData("PigShrineOption"), tasks={"Speak to the king"}}
	tasksetdata.set_pieces["VillageSquare"] = { count = GetModConfigData("VillageSquareOption"), tasks={"Make a pick", "Speak to the king"}}
	tasksetdata.set_pieces["PigGuards"] = { count = GetModConfigData("PigGuardsOption"), tasks={"Make a pick", "Forest hunters", "Speak to the king"}}
	tasksetdata.set_pieces["PigTown"] = { count = GetModConfigData("PigTownOption"), tasks={"Make a pick", "Speak to the king"}}
	tasksetdata.set_pieces["DefaultPigking"] = { count = GetModConfigData("DefaultPigkingOption"), tasks={"Speak to the king"}}
	tasksetdata.set_pieces["TorchPigking"] = { count = GetModConfigData("TorchPigkingOption"), tasks={"Speak to the king"}}
	tasksetdata.set_pieces["FisherPig"] = { count = GetModConfigData("FisherPigOption"), tasks={"Make a pick", "Speak to the king"}}
	tasksetdata.set_pieces["SwampPig"] = { count = GetModConfigData("SwampPigOption"), tasks={"Squeltch"}}
	tasksetdata.set_pieces["DeciduousPond"] = { count = GetModConfigData("DeciduousPondOption"), tasks={"Speak to the king"}}
	tasksetdata.set_pieces["ChessSpot1"] = { count = GetModConfigData("ChessSpot1Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}}
	tasksetdata.set_pieces["ChessSpot2"] = { count = GetModConfigData("ChessSpot2Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}}
	tasksetdata.set_pieces["ChessSpot3"] = { count = GetModConfigData("ChessSpot3Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}}
	tasksetdata.set_pieces["Maxwell1"] = { count = GetModConfigData("Maxwell1Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}}
	tasksetdata.set_pieces["Maxwell2"] = { count = GetModConfigData("Maxwell2Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}}
	tasksetdata.set_pieces["Maxwell3"] = { count = GetModConfigData("Maxwell3Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}}
	tasksetdata.set_pieces["Maxwell4"] = { count = GetModConfigData("Maxwell4Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}}
	tasksetdata.set_pieces["Maxwell5"] = { count = GetModConfigData("Maxwell5Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}}
	tasksetdata.set_pieces["Maxwell6"] = { count = GetModConfigData("Maxwell6Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}}
	tasksetdata.set_pieces["Maxwell7"] = { count = GetModConfigData("Maxwell7Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}}

	GLOBAL.dumptable(tasksetdata)
end)

AddTaskSetPreInitAny(function(tasksetdata)
	print("**********************************************************")
	print("**********************************************************")
	print("************* TASK SET PRE INIT FOR Cave !!! *************")
	print("**********************************************************")
	print("**********************************************************")
		if tasksetdata.location ~= "cave" then
			print("Bailing!")
			return
		end
	print("Applying!")

	tasksetdata.numoptionaltasks = GetModConfigData("RandomOptionalCaveBiomes")

	tasksetdata.set_pieces["TentaclePillar"] = { count = 10, tasks= {
		"MudWorld", "MudCave", "MudLights", "MudPit", "BigBatCave", "RockyLand", "RedForest", "GreenForest", "BlueForest", "SpillagmiteCaverns", "SwampySinkhole", "CaveSwamp", "UndergroundForest", "PleasantSinkhole", "FungalNoiseForest", "FungalNoiseMeadow", "BatCloister", "RabbitTown", "RabbitCity", "SpiderLand", "RabbitSpiderWar",
	} }
	tasksetdata.set_pieces["ResurrectionStone"] = { count = 2, tasks={
		"MudWorld", "MudCave", "MudLights", "MudPit", "BigBatCave", "RockyLand", "RedForest", "GreenForest", "BlueForest", "SpillagmiteCaverns", "SwampySinkhole", "CaveSwamp", "UndergroundForest", "PleasantSinkhole", "FungalNoiseForest", "FungalNoiseMeadow", "BatCloister", "RabbitTown", "RabbitCity", "SpiderLand", "RabbitSpiderWar",
	} }
	-- Cave Biomes Set Pieces
	tasksetdata.set_pieces["CaveBase"] = { count = GetModConfigData("CaveBaseOption"), tasks={"SpillagmiteCaverns", "BatCloister", "BigBatCave"}}
	tasksetdata.set_pieces["MushBase"] = { count = GetModConfigData("MushBaseOption"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "CaveSwamp", "RedForest", "GreenForest", "BlueForest"}}
	tasksetdata.set_pieces["SinkBase"] = { count = GetModConfigData("SinkBaseOption"), tasks={"PleasantSinkhole", "RedForest", "GreenForest", "BlueForest"}}
	tasksetdata.set_pieces["RabbitTown"] = { count = GetModConfigData("RabbitTownOption"), tasks={"PleasantSinkhole", "RedForest", "GreenForest", "BlueForest"}}
	tasksetdata.set_pieces["MilitaryEntrance"] = { count = GetModConfigData("MilitaryEntranceOption"), tasks={"Sacred"}}
	tasksetdata.set_pieces["RuinsCamp"] = { count = GetModConfigData("RuinsCampOption"), tasks={"Sacred"}}
	tasksetdata.set_pieces["AltarRoom"] = { count = GetModConfigData("AltarRoomOption"), tasks={"Sacred"}}
	tasksetdata.set_pieces["Spiral"] = { count = GetModConfigData("SpiralOption"), tasks={"Sacred"}}
	tasksetdata.set_pieces["BrokenAltar"] = { count = GetModConfigData("BrokenAltarOption"), tasks={"Sacred"}}
	tasksetdata.set_pieces["Chessy_1"] = { count = GetModConfigData("Chessy1Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "RockyLand", "RedForest", "GreenForest", "BlueForest"}}
	tasksetdata.set_pieces["Chessy_2"] = { count = GetModConfigData("Chessy2Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "RockyLand", "RedForest", "GreenForest", "BlueForest"}}
	tasksetdata.set_pieces["Chessy_3"] = { count = GetModConfigData("Chessy3Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "RockyLand", "RedForest", "GreenForest", "BlueForest"}}
	tasksetdata.set_pieces["Chessy_4"] = { count = GetModConfigData("Chessy4Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "RockyLand", "RedForest", "GreenForest", "BlueForest"}}
	tasksetdata.set_pieces["Chessy_5"] = { count = GetModConfigData("Chessy5Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "RockyLand", "RedForest", "GreenForest", "BlueForest"}}
	tasksetdata.set_pieces["Chessy_6"] = { count = GetModConfigData("Chessy6Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "RockyLand", "RedForest", "GreenForest", "BlueForest"}}
end)

AddTaskSet("infused",	{
        name="Infused",
		location = "forest",
		tasks = {
-- Default tasks
			"Make a pick",
			"Dig that rock",
			"Great Plains",
			"Squeltch",
			"Beeeees!",
			"Speak to the king",
			"Forest hunters",
			"Badlands",
			"For a nice walk",
			"Lightning Bluff",
-- Cave tasks
			"MudWorld",
			"MudCave",
			"MudLights",
			"MudPit",

			"BigBatCave",
			"RockyLand",
			"RedForest",
			"GreenForest",
			"BlueForest",
			"SpillagmiteCaverns",
-- Exit tasks
			"CaveExitTask1",
			"CaveExitTask2",
			"CaveExitTask3",
			"CaveExitTask4",
			"CaveExitTask5",
			"CaveExitTask6",
			"CaveExitTask7",
			"CaveExitTask8",
			"CaveExitTask9",
			"CaveExitTask10",
-- Ruins
			"LichenLand",
			"Residential",
--			"Military",
			"Sacred",
--			"TheLabyrinth",
			"SacredAltar",
			"InfusedWorld_MinotaurHome",
		},
		numoptionaltasks = GetModConfigData("InfusedWorldsRandomOptionalBiomes"),
		valid_start_tasks = {
			"Make a pick",
			},
-- Other Optional Tasks
		optionaltasks = {
			"Befriend the pigs",
			"For a nice walk",
			"Kill the spiders",
			"Killer bees!",
			"Make a Beehat",
			"The hunters",
			"Magic meadow",
			"Frogs and bugs",
			"Oasis",
			"Mole Colony Deciduous",
			"Mole Colony Rocks",
			"MooseBreedingTask",
-- Other Optional Cave Tasks
			"SwampySinkhole",
			"CaveSwamp",
			"UndergroundForest",
			"PleasantSinkhole",
--			"FungalNoiseForest",
--			"FungalNoiseMeadow",
			"BatCloister",
			"RabbitTown",
			"RabbitCity",
			"SpiderLand",
			"RabbitSpiderWar",
-- Ruins
			"MoreAltars",
			"CaveJungle",
			"SacredDanger",
--			"MilitaryPits",
			"MuddySacred",
			"Residential2",
			"Residential3",
		},
-- Set Pieces Tasks
		set_pieces = {
			["TentaclePillar"] = { count = 10, tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "BigBatCave", "RockyLand", "RedForest", "GreenForest", "BlueForest", "SpillagmiteCaverns", "SwampySinkhole", "CaveSwamp", "UndergroundForest", "PleasantSinkhole", "FungalNoiseForest", "FungalNoiseMeadow", "BatCloister", "RabbitTown", "RabbitCity", "SpiderLand", "RabbitSpiderWar",}},

			["ResurrectionStone"] = { count = GetModConfigData("ResurrectionStoneOption"), tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Badlands"}},
			["WormholeGrass"] = { count = 8, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"}},
			["MooseNest"] = { count = GetModConfigData("MooseSpawn"), tasks={"Make a pick", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Make a Beehat", "Magic meadow", "Frogs and bugs"}},
			["DragonflyArena"] = { count = GetModConfigData("DragonflySpawn"), tasks={"Badlands"}}, --Dragonfly Spawn Place
			["CaveEntrance"] = { count = 10, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"}},
-- Default Biomes Set Pieces
			["Farmplot"] = { count = GetModConfigData("FarmplotOption"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["StoneHenge"] = { count = GetModConfigData("StoneHengeOption"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
-- BROKEN			["CropCircle"] = { count = GetModConfigData("CropCircleOption"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "Beeeees!", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
-- BROKEN			["MushroomRingSmall"] = { count = GetModConfigData("MushroomRingSmallOption"), tasks={"Forest hunters", "Speak to the king", "Befriend the pigs", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
-- BROKEN			["MushroomRingMedium"] = { count = GetModConfigData("MushroomRingMediumOption"), tasks={"Forest hunters", "Speak to the king", "Befriend the pigs", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
-- BROKEN			["MushroomRingLarge"] = { count = GetModConfigData("MushroomRingLargeOption"), tasks={"Forest hunters", "Speak to the king", "Befriend the pigs", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["SimpleBase"] = { count = GetModConfigData("SimpleBaseOption"), tasks={"Dig that rock"}},
			["RuinedBase"] = { count = GetModConfigData("RuinedBaseOption"), tasks={"Dig that rock"}},
			["Grotto"] = { count = GetModConfigData("GrottoOption"), tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Badlands", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["LivingTree"] = { count = GetModConfigData("LivingTreeOption"), tasks={"Squeltch", "Forest hunters"}},
			["MacTuskTown"] = { count = GetModConfigData("MacTuskTownOption"), tasks={"Forest hunters", "Badlands"}},
			["MacTuskCity"] = { count = GetModConfigData("MacTuskCityOption"), tasks={"Forest hunters", "Badlands"}},
			["MaxMermShrine"] = { count = GetModConfigData("MermShrineOption"), tasks={"Squeltch"}},
			["MaxPigShrine"] = { count = GetModConfigData("PigShrineOption"), tasks={"Speak to the king"}},
			["VillageSquare"] = { count = GetModConfigData("VillageSquareOption"), tasks={"Make a pick", "Speak to the king"}},
			["PigGuards"] = { count = GetModConfigData("PigGuardsOption"), tasks={"Make a pick", "Forest hunters", "Speak to the king"}},
			["PigTown"] = { count = GetModConfigData("PigTownOption"), tasks={"Make a pick", "Speak to the king"}},
			["DefaultPigking"] = { count = GetModConfigData("DefaultPigkingOption"), tasks={"Speak to the king"}},
			["TorchPigking"] = { count = GetModConfigData("TorchPigkingOption"), tasks={"Speak to the king"}},
			["FisherPig"] = { count = GetModConfigData("FisherPigOption"), tasks={"Make a pick", "Speak to the king"}},
			["SwampPig"] = { count = GetModConfigData("SwampPigOption"), tasks={"Squeltch"}},
			["DeciduousPond"] = { count = GetModConfigData("DeciduousPondOption"), tasks={"Speak to the king"}},
			["ChessSpot1"] = { count = GetModConfigData("ChessSpot1Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["ChessSpot2"] = { count = GetModConfigData("ChessSpot2Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["ChessSpot3"] = { count = GetModConfigData("ChessSpot3Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell1"] = { count = GetModConfigData("Maxwell1Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell2"] = { count = GetModConfigData("Maxwell2Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell3"] = { count = GetModConfigData("Maxwell3Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell4"] = { count = GetModConfigData("Maxwell4Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell5"] = { count = GetModConfigData("Maxwell5Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell6"] = { count = GetModConfigData("Maxwell6Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell7"] = { count = GetModConfigData("Maxwell7Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
-- Cave Biomes Set Pieces
			["CaveBase"] = { count = GetModConfigData("CaveBaseOption"), tasks={"SpillagmiteCaverns", "BatCloister", "BigBatCave"}},
			["MushBase"] = { count = GetModConfigData("MushBaseOption"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "CaveSwamp", "RedForest", "GreenForest", "BlueForest"}},
			["SinkBase"] = { count = GetModConfigData("SinkBaseOption"), tasks={"PleasantSinkhole", "RedForest", "GreenForest", "BlueForest"}},
			["RabbitTown"] = { count = GetModConfigData("RabbitTownOption"), tasks={"PleasantSinkhole", "RedForest", "GreenForest", "BlueForest"}},
			["MilitaryEntrance"] = { count = GetModConfigData("MilitaryEntranceOption"), tasks={"Sacred"}},
			["RuinsCamp"] = { count = GetModConfigData("RuinsCampOption"), tasks={"Sacred"}},
			["AltarRoom"] = { count = GetModConfigData("AltarRoomOption"), tasks={"Sacred"}},
			["Spiral"] = { count = GetModConfigData("SpiralOption"), tasks={"Sacred"}},
			["BrokenAltar"] = { count = GetModConfigData("BrokenAltarOption"), tasks={"Sacred"}},
			["Chessy_1"] = { count = GetModConfigData("Chessy1Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "RockyLand", "RedForest", "GreenForest", "BlueForest"}},
			["Chessy_2"] = { count = GetModConfigData("Chessy2Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "RockyLand", "RedForest", "GreenForest", "BlueForest"}},
			["Chessy_3"] = { count = GetModConfigData("Chessy3Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "RockyLand", "RedForest", "GreenForest", "BlueForest"}},
			["Chessy_4"] = { count = GetModConfigData("Chessy4Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "RockyLand", "RedForest", "GreenForest", "BlueForest"}},
			["Chessy_5"] = { count = GetModConfigData("Chessy5Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "RockyLand", "RedForest", "GreenForest", "BlueForest"}},
			["Chessy_6"] = { count = GetModConfigData("Chessy6Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "RockyLand", "RedForest", "GreenForest", "BlueForest"}},
		},
	}
)

AddLevel(LEVELTYPE.SURVIVAL, { 
		id = "INFUSED",
		name = "Infused",
		desc = "A pleasing blend of forest and caves",
		location = "forest",
		version = 2,
		overrides = {
			task_set = "infused",
		},		
	})


-- Custom Ancient Guardian Spawn Biome
AddTask("InfusedWorld_MinotaurHome",	{
					locks={ LOCKS.NONE },
					keys_given={ KEYS.CAVE, KEYS.TIER1 },
						room_choices =
							{
								["InfusedWorld_MinotaurHome_BackgroundRoom"] = 2 * math.random(GLOBAL.SIZE_VARIATION),
								["InfusedWorld_MinotaurHome_Spawn"] = GetModConfigData("AncientGuardianSpawn"),
							},
						room_bg=GROUND.BRICK,
						background_room="InfusedWorld_MinotaurHome_BackgroundRoom",
						colour={r=0,g=0,b=0,a=0},
					}
	)

AddRoom("InfusedWorld_MinotaurHome_BackgroundRoom",	{
			colour={r=0.3,g=0.2,b=0.1,a=0.3},
			value = GROUND.BRICK, 
			contents =	{
					distributepercent = 0.15,
						distributeprefabs =
							{
								nightmarelight = 0.30,
								chessjunk1 = 0.1,
								chessjunk2 = 0.1,
								chessjunk3 = 0.1,
								ruins_statue_head = 0.1,
								ruins_statue_head_nogem = 0.2,
								ruins_statue_mage = 0.1,
								ruins_statue_mage_nogem = 0.2,
								rook_nightmare = 0.08,
								bishop_nightmare = 0.08,
								knight_nightmare = 0.08,
							}
					}
				}
	)

AddRoom("InfusedWorld_MinotaurHome_Spawn",	{
			colour={r=0.3,g=0.2,b=0.1,a=0.3},
			value = GROUND.BRICK, 
			contents =	{
			countstaticlayouts = 
						{
							["WalledGarden"] = 1,
						},          
					},
					}
	)
