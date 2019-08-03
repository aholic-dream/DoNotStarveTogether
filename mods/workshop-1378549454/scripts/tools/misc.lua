--[[
Copyright (C) 2018 Zarklord

This file is part of Gem Core.

The source code of this program is shared under the RECEX
SHARED SOURCE LICENSE (version 1.0).
The source code is shared for referrence and academic purposes
with the hope that people can read and learn from it. This is not
Free and Open Source software, and code is not redistributable
without permission of the author. Read the RECEX SHARED
SOURCE LICENSE for details 
The source codes does not come with any warranty including
the implied warranty of merchandise. 
You should have received a copy of the RECEX SHARED SOURCE
LICENSE in the form of a LICENSE file in the root of the source
directory. If not, please refer to 
<https://raw.githubusercontent.com/Recex/Licenses/master/SharedSourceLicense/LICENSE.txt>
]]

local containers = require("containers")

--Zarklord: i cant think of a reason why you would want to access this
--but if its needed I can add a api for you to access the raw container
local params = UpvalueHacker.GetUpvalue(containers.widgetsetup, "params")

local function AddContainerWidget(name, data)
	params[name] = data
end

--extremly useful for debugging' as you dont need to write unique messages for checking code path's if you want to check this way.
local function DebugPrint(message)
	print((debug.getinfo(2,'S').source or "Unkown Source").." "..(debug.getinfo(2, "n").name or "Unkown Name").." "..(debug.getinfo(2, 'l').currentline or "Unkown Line").." "..(message or ""))
end


local function MakeEquippablePrefab(prefab, img_atlas, ...)
    local pref = Prefab(prefab, ...)
    pref.img_atlas = img_atlas
    return pref
end

--Patch to allow all inventory images to stay in 1 file.
local PlayerAvatarPopup = require("widgets/playeravatarpopup")
local EquipSlot = require("equipslotutil")
local _oldUpdateEquipWidgetForSlot = PlayerAvatarPopup.UpdateEquipWidgetForSlot
function PlayerAvatarPopup:UpdateEquipWidgetForSlot(image_group, slot, equipdata, stop)
    _oldUpdateEquipWidgetForSlot(self, image_group, slot, equipdata, true)
    if stop == nil then --Make sure that if this patch was already applied in a different mod then it doesn't run the same code repeatedly
        local name = equipdata ~= nil and equipdata[EquipSlot.ToID(slot)] or nil
        name = name ~= nil and #name > 0 and name or "none"
        if name ~= "none" then
            if Prefabs[name] ~= nil and Prefabs[name].img_atlas ~= nil and Prefabs[name].current_skin == nil --[[So as not to conflict with Modded Skins' patch]] then
                if softresolvefilepath(Prefabs[name].img_atlas) ~= nil then
                    image_group._image:SetTexture(Prefabs[name].img_atlas, name..".tex") --Don't need defaults because those should already be set prior to getting to these very specific ifs
                end
            end
        end
    end
end

local function GetNextAvaliableCollisionMask()
    local mask = 0
    for k, v in pairs(COLLISION) do
        mask = bit.bor(mask, v)
    end
    local i = 1
    while i <= 0x7FFF do
        if bit.band(mask, i) == 0 then
            print("Collision Mask: ", i, " Found!")
            return i
        end
        i = i * 2
    end
    print("ERROR: Ran out of available collision mask's")
    return 0
end

local function upvalue_next(t, index)
    index = index + 1
    local n, v = debug.getupvalue(t, index)
    if n then
        return index, n, v
    end
end

function upvalueslist(t)
    return upvalue_next, t, 0
end

return {
	Global = {
		DebugPrint = DebugPrint,
		MakeEquippablePrefab = MakeEquippablePrefab,
        GetNextAvaliableCollisionMask = GetNextAvaliableCollisionMask,
        upvalueslist = upvalueslist,
	},
	Local = {
		DebugPrint = DebugPrint,
		AddContainerWidget = AddContainerWidget,
        upvalueslist = upvalueslist,
	},
}