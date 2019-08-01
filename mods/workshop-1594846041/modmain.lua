_G = GLOBAL
assert = _G.assert
error = _G.error
require = _G.require

local Highlight = require "components/highlight"
 
--------------------------------------------------------------------
local SELECTION_BOX_MODIFIER = assert(_G.KEY_SHIFT)
local CHERRY_PICKING_MODIFIER = SELECTION_BOX_MODIFIER

--------------------------------------------------------------------
Assets = {
	Asset( "ATLAS", "images/selection_square.xml" ),
	Asset( "IMAGE", "images/selection_square.tex" ),
}

local aq_keys = {
	["SHIFT"] = _G.KEY_SHIFT,
	["ALT"] = _G.KEY_ALT,
	["Z"] = _G.KEY_Z,
	["X"] = _G.KEY_X,
	["C"] = _G.KEY_C,
	["V"] = _G.KEY_V,
	["B"] = _G.KEY_B,
}

--------------------------------------------------------------------
local function pfn(player)
	player:DoTaskInTime(1,function() 
		local inst = _G.ThePlayer
		if not inst or not inst.components.playercontroller then
			player:DoTaskInTime(1,function() pfn(player) end)
			return
		end
		if not inst.components.actionqueuer then
			print("AddActionQueuerComponent")
			--inst:EnableMovementPrediction(false)
			inst:AddComponent("actionqueuer")
			--if GetModConfigData("isNewDstVersion") == "yes" then
			inst.components.actionqueuer:SetConfig(true)
			--end
			if GetModConfigData("autoCollect") == "yes" then 
				inst.components.actionqueuer.doAutoCollect = true
			end
			SELECTION_BOX_MODIFIER = aq_keys[GetModConfigData("aqKey")]
			CHERRY_PICKING_MODIFIER = SELECTION_BOX_MODIFIER
			inst.components.actionqueuer:SetSelectionBoxModifier(SELECTION_BOX_MODIFIER)
			inst.components.actionqueuer:SetCherryPickingModifier(CHERRY_PICKING_MODIFIER)
			local pc = inst.components.playercontroller
			pc.OnControl = (function()
				local OnControl = pc.OnControl
				return function(self, ...)
					if not (SELECTION_BOX_MODIFIER and _G.TheInput:IsKeyDown(SELECTION_BOX_MODIFIER)) and not (CHERRY_PICKING_MODIFIER and _G.TheInput:IsKeyDown(CHERRY_PICKING_MODIFIER)) then
						if _G.TheInput:IsControlPressed(_G.CONTROL_MOVE_UP) or _G.TheInput:IsControlPressed(_G.CONTROL_MOVE_DOWN) or _G.TheInput:IsControlPressed(_G.CONTROL_PRIMARY) or
						   _G.TheInput:IsControlPressed(_G.CONTROL_MOVE_LEFT) or _G.TheInput:IsControlPressed(_G.CONTROL_MOVE_RIGHT) or _G.TheInput:IsControlPressed(_G.CONTROL_SECONDARY) or
						   _G.TheInput:IsControlPressed(_G.CONTROL_ATTACK) then
							inst.components.actionqueuer:Interrupt()
						end
						return OnControl(self, ...)
					end
				end
			end)()	
		end
		if GetModConfigData("repeatMake") == "yes" then
			if inst and inst.replica and inst.replica.builder and inst.replica.builder.MakeRecipeFromMenu then
				local MakeRecipeFromMenu = inst.replica.builder.MakeRecipeFromMenu
				inst.replica.builder.MakeRecipeFromMenu = function(self, recipe, skin)
					if _G.TheInput:IsKeyDown(SELECTION_BOX_MODIFIER) and recipe.placer == nil then
						inst.components.actionqueuer:RepeatRecipe(recipe, skin)
					else
						MakeRecipeFromMenu(inst.replica.builder,recipe, skin)
					end
				end
			end
		end
	end)
end
AddPlayerPostInit(pfn)

Highlight.UnHighlight = (function()
	local UnHighlight = assert(Highlight.UnHighlight)
	return function(self, ...)
		local p = GLOBAL.ThePlayer
		if p and p.components.actionqueuer and p.components.actionqueuer:IsSelectedEntity(self.inst) then
			return
		end
		return UnHighlight(self, ...)
	end
end)()
