--Thanks NSimplex!

--[[
-- Receives a Prefab object, and tweaks its entity constructor ("fn") to
-- make the prefab be loaded before it is spawned.
--]]

local replacedfns = {}
local _getupvalue = debug.getupvalue
function debug.getupvalue(fn, ...)
    return _getupvalue(replacedfns[fn] or fn, ...)
end
local function MakeLazyLoader(prefab)
	if prefab.fn then
		local fn = prefab.fn
		local current_fn

		local function new_fn(...)
            TheSim:UnloadPrefabs({prefab.name})
			TheSim:LoadPrefabs({prefab.name})

			-- Ensures this only runs once, for efficiency.
			current_fn = fn

			return fn(...)
		end

		current_fn = new_fn

		--[[
		-- This extra layer of indirection ensures greater mod friendliness.
		--
		-- If we just set prefab.fn to new_fn, and later back to fn, we could
		-- end up overriding an fn patch done by another mod. By switching between
		-- the two internally, via the current_fn upvalue, we preserve any such
		-- patching.
		--]]
		prefab.fn = function(...)
			return current_fn(...)
		end
        replacedfns[prefab.fn] = fn
	else
		--Prefab's without a .fn get loaded immediatly, since its just assets for Skins
        TheSim:UnloadPrefabs({prefab.name})
		TheSim:LoadPrefabs({prefab.name})
	end
end

------------------------------------------------------------------------

local ModMananger_RegisterPrefabs = ModManager.RegisterPrefabs
function ModManager.RegisterPrefabs(self, ...)
    local _RegisterPrefabs = RegisterPrefabs

    local mod_prefabnames = {}

    RegisterPrefabs = function(...)
        for _, prefab in ipairs({...}) do
            local moddir = prefab.name:match("^MOD_(.+)$")
            if moddir then
                --print("MEMFIXING "..moddir)
                for _, name in ipairs(prefab.deps) do
                    table.insert(mod_prefabnames, name)
                end

                prefab.deps = {}
                --print("Purged deps from "..prefab.name)
            end
        end
        return _RegisterPrefabs(...)
    end

    ModMananger_RegisterPrefabs(self, ...)

    RegisterPrefabs = _RegisterPrefabs

    -- First, do a pass over recipes to extend dependencies if need be.
    for k, v in pairs(AllRecipes) do
        table.removearrayvalue(mod_prefabnames, v.name)
        if v.placer then
            table.removearrayvalue(mod_prefabnames, v.placer)
        end
    end

    for _, prefabname in ipairs(mod_prefabnames) do
        --print("Registering "..prefabname)
        
        local prefab = Prefabs[prefabname]

        _RegisterPrefabs(prefab)

        MakeLazyLoader(prefab)

        -- This also takes care of the unloading, so there's no need to patch ModWrangler:UnloadPrefabs.
        table.insert(self.loadedprefabs, prefabname)
    end

    --re-reset this with modded recipes.
    RECIPE_PREFABS = {}
    for k,v in pairs(AllRecipes) do
        table.insert(RECIPE_PREFABS, v.name)
        if v.placer then
            table.insert(RECIPE_PREFABS, v.placer)
        end
    end
end
