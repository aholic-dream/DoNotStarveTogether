--[[
Copyright (C) 2019 Zarklord

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

--Global Pause Patches
if not TheNet:IsDedicated() then
    --This patch properly "pauses" sound
    local Mixer = require("mixer")

    function Mixer.Mixer:DeleteMix(mixname)
        local top = self.stack[1]
        for k, v in ipairs(self.stack) do
            if mixname == v.name then
                table.remove(self.stack, k)
                if top ~= self.stack[1] then
                    self.stack[1]:Apply()
                end
                break
            end
        end
    end

    local amb = "set_ambience/ambience"
    local cloud = "set_ambience/cloud"
    local music = "set_music/soundtrack"
    local voice = "set_sfx/voice"
    local movement ="set_sfx/movement"
    local creature ="set_sfx/creature"
    local player ="set_sfx/player"
    local HUD ="set_sfx/HUD"
    local sfx ="set_sfx/sfx"
    local slurp ="set_sfx/everything_else_muted"

    TheMixer:AddNewMix("globalpause", 0, 2147483647,
    {
        [amb] = 0,
        [cloud] = 0,
        [music] = 0,
        [voice] = 0,
        [movement] = 0,
        [creature] = 0,
        [player] = 0,
        [HUD] = 1,
        [sfx] = 0,
        [slurp] = 0,
    })

    GEMENV.AddComponentPostInit("globalpause", function(self)
        self.inst:ListenForEvent("pausestatedirty", function(net_world)
            --i am fairly certain no explosions will go off from checking TheWorld.ispaused, since the OnPauseStateDirty function runs first right?
            if TheWorld.ispaused then
                TheMixer:PushMix("globalpause")
            else
                TheMixer:DeleteMix("globalpause")
            end
        end)
    end)
end