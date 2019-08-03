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

--[[
Okay here is the deal with how this works:
We need some function that we can send a custom data from the lua side of the slave shard servers, to the lua side of the master shard.
(Slave Lua to Slave C to Master C to Master Lua)
Tecnicaly we only need to be able to send a custom string since we can load a string as raw lua code,
THE ONLY way of doing this is the Announcements/SystemMessage system.
so we do a "System Message" with the unique prefix HSR(HandleShardRPC) if we encounter a system message with the prefix HSR,
we block it from reaching the player's screen and if its the intended shards we execute the string code.
there is some semi complicated code converting your arguments to a string.
the only thing you cant actually send directly is enitities(though they wouldn't exist on the master shard generaly anyway).
]]

local shard_components = {}

MODENV.AddGlobalClassPostConstruct("entityscript", "EntityScript", function(inst)
--addprefabpostinit doesnt beat a certain line of code, to running so we have to check if a component is being added that only gets added for the prefab "shard_network"
	local old_AddComponent = inst.AddComponent
	inst.AddComponent = function(self, name)
        old_AddComponent(self, name)
		if name == "shard_autosaver" then
            for i, v in ipairs(shard_components) do
                old_AddComponent(self, v)
            end
		end
	end
end)

SHARD_LIST = {}
SHARD_RPC_HANDLERS = {}
SHARD_RPC = {}

local function __index_lower(t, k)
    return rawget(t, string.lower(k))
end

local function __newindex_lower(t, k, v)
    rawset(t, string.lower(k), v)
end

local function setmetadata( tab )
    setmetatable(tab, { __index = __index_lower, __newindex = __newindex_lower })
end

local old_Networking_SystemMessage = Networking_SystemMessage
Networking_SystemMessage = function(message)
	if string.sub(message, 1, 3) == "HSR" then
        if TheWorld.ismastersim then
			loadstring("HandleShardRPC("..string.sub(message, 4)..")")()
		end
	else
		old_Networking_SystemMessage(message)
	end
end

function AddShardRPCHandler(namespace, name, fn)
    if SHARD_RPC[namespace] == nil then
        SHARD_RPC[namespace] = {}
        SHARD_RPC_HANDLERS[namespace] = {}

        setmetadata(SHARD_RPC[namespace])
        setmetadata(SHARD_RPC_HANDLERS[namespace])
    end

    table.insert(SHARD_RPC_HANDLERS[namespace], fn)
    SHARD_RPC[namespace][name] = { namespace = namespace, id = #SHARD_RPC_HANDLERS[namespace] }

    setmetadata(SHARD_RPC[namespace][name])
end

function HandleShardRPC(shard_id, shardlist, namespace, code, ...)
    if type(shardlist) == "number" then
        shardlist = {shardlist}
    end
    if SHARD_RPC_HANDLERS[namespace] ~= nil then
        local fn = SHARD_RPC_HANDLERS[namespace][code]
        if fn ~= nil then
            if shard_id ~= TheShard:GetShardId() and (shardlist == nil or table.contains(shardlist, tonumber(TheShard:GetShardId()))) then
                fn(shard_id, ...)
            end
        else
            print("Invalid Shard RPC code: ", namespace, code)
        end
    else
        print("Invalid Shard RPC namespace: ", namespace, code)
    end
end

local function dump(val)
    return DataDumper(val, '', true)
end

function SendShardRPC(id_table, shardlist, ...)
    assert(id_table.namespace ~= nil and SHARD_RPC_HANDLERS[id_table.namespace] ~= nil and SHARD_RPC_HANDLERS[id_table.namespace][id_table.id] ~= nil)

    --convert args to string format
	local ArgStrings = {}
    ArgStrings[#ArgStrings+1] = dump(TheShard:GetShardId())
    --if we only have a single shard were sending to we can optimize by not sending it as a table
    --quick and dirty code that ensure all entires are A: numbers and B: that if there is only one entry in a table its passed as a number instead
    if type(shardlist) == "table" and #shardlist == 1 then 
        shardlist = tonumber(shardlist[1])
    elseif type(shardlist) == "string" then
        shardlist = tonumber(shardlist)
    elseif type(shardlist) == "table" then
        local newlist = {}
        for i, v in ipairs(shardlist) do
            local num = tonumber(v)
            if num then
                newlist[#newlist + 1] = num
            end
        end
        shardlist = newlist
    end
    ArgStrings[#ArgStrings+1] = dump(shardlist)
    ArgStrings[#ArgStrings+1] = dump(id_table.namespace)
    ArgStrings[#ArgStrings+1] = dump(id_table.id)

    local args = {n = select("#", ...), ...}
    for i=1,args.n do
    	ArgStrings[#ArgStrings+1] = dump(args[i])
    end
    local Arguments = table.concat(ArgStrings, ",")
    
	TheNet:SystemMessage("HSR"..Arguments)
end

--small helper function for pure slave -> master communication
function SendShardRPCToServer(id_table, ...)
    SendShardRPC(id_table, tonumber(SHARDID.MASTER), ...)
end

local function AddShardComponent(name)
    table.insert(shard_components, name)
end

function GetShardReportDataFromWorld(data)
    if TheWorld:HasTag("forest") then
        table.insert(data.tags, "forest")
    end
    if TheWorld:HasTag("cave") then
        table.insert(data.tags, "cave")
    end
    return data
end


--todo what other things might we want in the shard list?
local function ShardReportInfo(shard_id, fromShardID, shardData)
    if TheWorld.ismastershard then 
        TheWorld:PushEvent("new_shard_report", {fromShard = fromShardID, data = DataDumper(shardData, nil, false)})
    end
end
AddShardRPCHandler("GemCore", "ShardReportInfo", ShardReportInfo)

return AddShardComponent