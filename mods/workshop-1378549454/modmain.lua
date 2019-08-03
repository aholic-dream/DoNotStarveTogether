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

local _G = GLOBAL
local require = _G.require

--MODENV is DEPRECIATED
_G.MODENV = env
_G.GEMENV = env

--should be in both namespaces
_G.UpvalueHacker = require("tools/upvaluehacker")
_G.LocalVariableHacker = require("tools/localvariablehacker")

local CustomTechTree = require("tools/customtechtree")

local AddNaughtinessFor = require("tools/krampednaughtiness")

--EntityScript namepsace only
local AddSpoofedReplicableComponent = require("tools/componentspoofer")

--only needs to be in the global namespace except for AddShardComponent
local AddShardComponent = require("tools/shardrpc")
AddShardComponent("shard_report")

require("mathutils")
require("tableutils")
_G.bit = require("bit")

--we gonna do do some interesting stuff with this
local MiscStuff = require("tools/misc")

require("memspikefix")

require("tools/physicscollisions")

require("tools/soundmanager")

require("globalpause_patches")

_G.GlobalMetatable = require("tools/globalmetatable")

for k, v in pairs(MiscStuff.Global) do
	GLOBAL[k] = v
end

_G.SetupGemCoreEnv = function(enviroment)
	_G.setfenv(1, enviroment or _G.getfenv(2))
	env.UpvalueHacker = _G.UpvalueHacker
    env.LocalVariableHacker = _G.LocalVariableHacker
    env.CustomTechTree = CustomTechTree
	env.AddSpoofedReplicableComponent = AddSpoofedReplicableComponent
	env.AddShardComponent = AddShardComponent
	env.bit = _G.bit
    env.AddNaughtinessFor = AddNaughtinessFor
    env.SetSoundAlias = _G.SetSoundAlias
    env.GlobalMetatable = _G.GlobalMetatable
	for k, v in pairs(MiscStuff.Local) do
		env[k] = v
	end
end

_G.SetupGemCoreEnv()
--after initializing, run beta fixes.
if CurrentRelease.GreaterOrEqualTo("R08_ROT_TURNOFTIDES") then
    modimport("gemscripts/betafixes")
end

local _InitializeModMain = _G.ModManager.InitializeModMain
function _G.ModManager:InitializeModMain(modname, env, mainfile, ...)
    if mainfile == "modmain.lua" then
        env.SetupGemCoreEnv = function() _G.SetupGemCoreEnv(env) end
    end
    return _InitializeModMain(self, modname, env, mainfile, ...)
end