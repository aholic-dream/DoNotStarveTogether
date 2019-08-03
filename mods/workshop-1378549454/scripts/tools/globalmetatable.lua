local _rawget = rawget
local _rawset = rawset

local secret = {
    __index = {},
    __newindex = {},
}

function rawget(t, n)
    if t == _G and secret.__index[n] then
        local ret = secret.__index[n]
        if type(ret) == "function" then
            return ret(t, n)
        else
            return ret
        end
    end
    return _rawget(t, n)
end

function rawset(t, n, v)
    if t == _G and secret.__newindex[n] then
        return secret.__newindex[n](t, n, v)
    end
    return _rawset(t, n, v)
end

local function noset() return end

local GlobalMetatable = {}

function GlobalMetatable.AddGetSet(name, get, set)
    assert(secret.__index[name] == nil and secret.__newindex[name] == nil, "ERROR! AddingGetSet for already existing GetSet: "..name..".")
    set = set or noset
    assert(type(get) == "function", "ERROR! get must be a function!")
    assert(type(set) == "function", "ERROR! set must be a function!")
    assert(type(name) == "string", "ERROR! name must be a string!")
    secret.__index[name] = get 
    secret.__newindex[name] = set
end

local blacklist = {
    ["TheLocalPlayer"] = false,
}

function GlobalMetatable.RemoveGetSet(name)
    assert(blacklist[name] == nil, "ERROR! cant remove blacklisted GetSet!")
    secret.__index[name] = nil 
    secret.__newindex[name] = nil
end

global("TheLocalPlayer")

GlobalMetatable.AddGetSet("TheLocalPlayer", function(t, n)
    return not TheNet:IsDedicated() and ThePlayer or nil
end)

return GlobalMetatable