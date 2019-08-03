local _G = GLOBAL
local require = _G.require

_G.global("HASFRONTENDLOADEDGEMCORE")
_G.global("GEMWORLDGENCALLBACKS")

_G.GEMWORLDGENENV = env

local IsTheFrontEnd = GLOBAL.rawget(GLOBAL, "TheFrontEnd") and GLOBAL.rawget(GLOBAL, "IsInFrontEnd") and GLOBAL.IsInFrontEnd()
env.IsTheFrontEnd = IsTheFrontEnd

--should be in both namespaces
_G.UpvalueHacker = require("tools/upvaluehacker")
_G.LocalVariableHacker = require("tools/localvariablehacker")

require("mathutils")
require("tableutils")
_G.bit = require("bit")

local WorldGenOptions = require("tools/worldgenoptions")

local DynamicTileManager = require("tools/dynamictilemanager")

local MapTagger = require("map/tools/maptagger")

local AssetLoader = require("assetloader")

--specifically get debug print.
_G.DebugPrint = require("tools/misc").Global.DebugPrint

_G.GlobalMetatable = require("tools/globalmetatable")

--basic deal, the front end of worldgen has a **COMPLETLY** different use than everything else
--so im forcing good standards by splitting the frontend code(via this callback) and the rest of the code
--where you will do:
--if _G.rawget(GLOBAL, "TheFrontEnd") ~= nil then
--    --your code here
--end
_G.SetupGemCoreWorldGenEnv = function() end

local function CommonWorldGenEnv(enviroment)
    _G.setfenv(1, enviroment)
    env.DebugPrint = _G.DebugPrint
    env.UpvalueHacker = _G.UpvalueHacker
    env.LocalVariableHacker = _G.LocalVariableHacker
    env.bit = _G.bit
    env.WorldGenOptions = _G.deepcopy(WorldGenOptions)
    local _ListenForEvent = env.WorldGenOptions.ListenForEvent
    function env.WorldGenOptions.ListenForEvent(...)
        return _ListenForEvent(env.modname, ...)
    end
    local _RemoveEventCallback = env.WorldGenOptions.RemoveEventCallback
    function env.WorldGenOptions.RemoveEventCallback(...)
        return _RemoveEventCallback(env.modname, ...)
    end
    env.GlobalMetatable = _G.GlobalMetatable
end

if IsTheFrontEnd then
    local function SetupGemCoreWorldGenEnv(enviroment)
        _G.setfenv(1, enviroment)
        CommonWorldGenEnv(env)
        function env.ReloadFrontEndAssets()
            AssetLoader.UnloadAssets(enviroment.modname or true)--we do the "or true", to prevent nil getting passed which is how we signal deletion of all frontend_assets_prefabs.
            if enviroment.frontendassets then
                AssetLoader.LoadAssets(enviroment.modname, enviroment.frontendassets)
            end
        end
        env.ReloadFrontEndAssets()
    end

    SetupGemCoreWorldGenEnv(env)

    --after initializing, run beta fixes.
    if CurrentRelease.GreaterOrEqualTo("R08_ROT_TURNOFTIDES") then
        modimport("gemscripts/betafixes_frontend")
    end

    local function CallWorldgenModCallback(callback)
        local enviroment = _G.getfenv(callback)
        _G.setfenv(1, enviroment)
        _G.ModManager.currentlyloadingmod = enviroment.modname
        local oldpath = _G.package.path
        _G.package.path = enviroment.MODROOT.."\\scripts\\?.lua;".._G.package.path
        SetupGemCoreWorldGenEnv(enviroment)
        _G.RunInEnvironmentSafe(callback, enviroment)
        _G.package.path = oldpath
        _G.ModManager.currentlyloadingmod = modname
        _G.setfenv(1, _G.GEMWORLDGENENV)
    end

    if _G.GEMWORLDGENCALLBACKS ~= nil then
        for i, v in ipairs(_G.GEMWORLDGENCALLBACKS) do
            CallWorldgenModCallback(v)
        end
    end
    _G.GEMWORLDGENCALLBACKS = _G.setmetatable({}, {__newindex = function(t, k, v)
        CallWorldgenModCallback(v)
    end})

    if not _G.HASFRONTENDLOADEDGEMCORE then
        --for frontend loading/unloading your mod.
        local _FrontendUnloadMod = _G.ModManager.FrontendUnloadMod
        function _G.ModManager:FrontendUnloadMod(modname, ...)
            _FrontendUnloadMod(self, modname, ...)
            if modname == nil or modname == _G.GEMWORLDGENENV.modname then
                _G.GEMWORLDGENCALLBACKS = nil
            end
            AssetLoader.UnloadAssets(modname)
        end
        local _FrontendLoadMod = _G.ModManager.FrontendLoadMod
        function _G.ModManager:FrontendLoadMod(modname, ...)
            _FrontendLoadMod(self, modname, ...)
        end
        _G.HASFRONTENDLOADEDGEMCORE = true
    end
else
    _G.SetupGemCoreWorldGenEnv = function(enviroment)
        _G.setfenv(1, enviroment or _G.getfenv(2))
        CommonWorldGenEnv(env)
        env.DynamicTileManager = DynamicTileManager
        env.MapTagger = MapTagger
    end

    _G.SetupGemCoreWorldGenEnv()

    --after initializing, run beta fixes.
    if CurrentRelease.GreaterOrEqualTo("R08_ROT_TURNOFTIDES") then
        modimport("gemscripts/betafixes_worldgen")
    end

    local _InitializeModMain = _G.ModManager.InitializeModMain
    function _G.ModManager:InitializeModMain(modname, env, mainfile, ...)
        if mainfile == "modworldgenmain.lua" then
            env.SetupGemCoreWorldGenEnv = function() _G.SetupGemCoreWorldGenEnv(env) end
            env.IsTheFrontEnd = IsTheFrontEnd
        end
    return _InitializeModMain(self, modname, env, mainfile, ...)
    end
end