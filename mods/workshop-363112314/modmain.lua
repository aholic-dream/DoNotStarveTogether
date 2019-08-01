GLOBAL.require("consolecommands")

--[[
	New function IsKeyBinding to test if currently pressed keys match desired key binding
	Created by: WrathOf
--]]
local function IsKeyBinding(key, modifiers)
	if GLOBAL.TheInput:IsKeyDown(key) then
		if modifiers then
			for k,v in ipairs(modifiers) do
				if not GLOBAL.TheInput:IsKeyDown(v) then return false end
			end
			return true
		else
			return not ( GLOBAL.TheInput:IsKeyDown(KEY_CTRL) or GLOBAL.TheInput:IsKeyDown(KEY_SHIFT) or GLOBAL.TheInput:IsKeyDown(KEY_ALT) )
		end
	else
	  return false
	end
end

local rev = string.format("local w,h = TheWorld.Map:GetSize();for _,v in pairs(AllPlayers) do for x=-w*4,w*4,35 do for y=-h*4,h*4,35 do v.player_classified.MapExplorer:RevealArea(x,0,y) end end end")
local fog = string.format("TheWorld.minimap.MiniMap:EnableFogOfWar(false)")

local function revealer( inst )
	
	if GLOBAL.TheNet:GetIsClient() and GLOBAL.TheNet:GetIsServerAdmin() then
		GLOBAL.TheNet:SendRemoteExecute(rev, x, z)	
	else
		GLOBAL.ExecuteConsoleCommand(rev)
	end
	
end

local function revealer2(inst)

	if GLOBAL.TheNet:GetIsClient() and GLOBAL.TheNet:GetIsServerAdmin() then
		GLOBAL.TheNet:SendRemoteExecute(fog, x, z)	
	else
		GLOBAL.ExecuteConsoleCommand(fog)
	end
end

GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_R, function()
		if  IsKeyBinding(GLOBAL.KEY_R, {GLOBAL.KEY_SHIFT}) then
			revealer()
		end
	end)
	
GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_F, function()
		if  IsKeyBinding(GLOBAL.KEY_F, {GLOBAL.KEY_SHIFT}) then
			revealer2()
		end
	end)