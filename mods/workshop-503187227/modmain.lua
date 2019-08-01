-- Definitions
local LightsOutStartingItems = GetModConfigData("LightsOutStartingItems")
local OverworldNightmarePhase = GetModConfigData("OverworldNightmarePhase")

-- Toadstool spawner (Thanks to Swaggy for finding this out)
AddPrefabPostInit("world",function()
	if GLOBAL.TheWorld.ismastersim then
		GLOBAL.TheWorld:AddComponent("toadstoolspawner")
	end
end)

-- Adds starting items
local OnPlayerSpawnIn = function(src, player)
	player.prev_OnNewSpawnFn1 = player.OnNewSpawn
	player.OnNewSpawn = function()

		local StartingItemsLightsOutMode = {}

		if LightsOutStartingItems > 0 then
			for i = 1, 1 do
				table.insert(StartingItemsLightsOutMode, "lantern")
			end
			for i = 1, 10 do
				table.insert(StartingItemsLightsOutMode, "slurtleslime")
			end
		end

		for k,v in pairs(StartingItemsLightsOutMode) do
			local item = GLOBAL.SpawnPrefab(v)

			player.components.inventory:GiveItem(item)
		end   

		if player.prev_OnNewSpawnFn1 ~= nil then
			player:prev_OnNewSpawnFn1()
			player.prev_OnNewSpawnFn1 = nil
		end
	end
end

local function ListenForPlayerSpawn(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:ListenForEvent("ms_playerspawn", OnPlayerSpawnIn)
	end
end

AddPrefabPostInit("world", ListenForPlayerSpawn)

-- Adds Nightmare Phase function to overworld (Thank you for this Muche)
if OverworldNightmarePhase > 0 then

	AddPrefabPostInit("forest_network", function(inst)
		inst:AddComponent("nightmareclock")
	end)

	if GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer() then
		AddSimPostInit(function()
			if GLOBAL.TheWorld and not GLOBAL.TheWorld:HasTag("cave") then
				for i, node in ipairs(GLOBAL.TheWorld.topology.nodes) do
					if node.tags == nil then
						node.tags = {}
					end
					table.insert(node.tags, "Nightmare")
				end
			end
		end)
	end

	AddPlayerPostInit(function(inst)
		if GLOBAL.TheWorld and not GLOBAL.TheWorld:HasTag("cave") then
			inst:RemoveComponent("areaaware")
		end
	end)

end
