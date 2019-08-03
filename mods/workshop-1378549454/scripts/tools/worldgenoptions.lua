local Customize = require("map/customise")
local Levels = require("map/levels")

local GROUP = UpvalueHacker.GetUpvalue(Customize.ValidateOption, "GROUP")
local DEFAULT_GROUP = deepcopy(GROUP)

local defaultdescs = {}

defaultdescs.frequency_descriptions = deepcopy(GROUP.monsters.desc)
defaultdescs.starting_swaps_descriptions = deepcopy(GROUP.misc.items.prefabswaps_start.desc)
defaultdescs.petrification_descriptions = deepcopy(GROUP.misc.items.petrification.desc)
defaultdescs.speed_descriptions = deepcopy(GROUP.misc.items.regrowth.desc)
defaultdescs.disease_descriptions = deepcopy(GROUP.misc.items.disease_delay.desc)
defaultdescs.day_descriptions = deepcopy(GROUP.misc.items.day.desc)
defaultdescs.season_length_descriptions = deepcopy(GROUP.misc.items.autumn.desc)
defaultdescs.season_start_descriptions = deepcopy(GROUP.misc.items.season_start.desc)
defaultdescs.size_descriptions = deepcopy(GROUP.misc.items.world_size.desc)
defaultdescs.branching_descriptions = deepcopy(GROUP.misc.items.branching.desc)
defaultdescs.loop_descriptions = deepcopy(GROUP.misc.items.loop.desc)
defaultdescs.complexity_descriptions = deepcopy({
    {text = STRINGS.UI.SANDBOXMENU.SLIDEVERYSIMPLE, data = "verysimple"},
    {text = STRINGS.UI.SANDBOXMENU.SLIDESIMPLE, data = "simple"},
    {text = STRINGS.UI.SANDBOXMENU.SLIDEDEFAULT, data = "default"},
    {text = STRINGS.UI.SANDBOXMENU.SLIDECOMPLEX, data = "complex"},
    {text = STRINGS.UI.SANDBOXMENU.SLIDEVERYCOMPLEX, data = "verycomplex"},
})
defaultdescs.specialevent_descriptions = deepcopy(GROUP.misc.items.specialevent.desc)
defaultdescs.yesno_descriptions = deepcopy({
    {text = STRINGS.UI.SANDBOXMENU.YES, data = "default"},
    {text = STRINGS.UI.SANDBOXMENU.NO, data = "never"},
})

local WorldGenOptions = {}

local CUSTOMGROUPLABELS = {}

local _GetOptions = Customize.GetOptions
function Customize.GetOptions(...)
    local options = _GetOptions(...)
    for i, v in ipairs(options) do
        options[i].atlas = GROUP[v.group].items[v.name].atlas or nil
        options[i].alwaysedit = GROUP[v.group].items[v.name].alwaysedit or nil
        options[i].neveredit = GROUP[v.group].items[v.name].neveredit or nil
    end
    return options
end

UpvalueHacker.SetUpvalue(Customize.GetOptionsWithLocationDefaults, function(...)
    return Customize.GetOptions(...)
end, "GetOptions")

local _stringformat = string.format
function string.format(fmt, opt1, opt2, opt3, ...)
    if fmt == "%s %s" and table.contains(STRINGS.UI.SANDBOXMENU.LOCATION, opt1) and table.contains(CUSTOMGROUPLABELS, opt2) and opt3 == nil then
        fmt = "%s"
        return _stringformat(fmt, opt2)
    end
    return _stringformat(fmt, opt1, opt2, opt3, ...)
end

local refreshworldtabs = GEMWORLDGENENV.IsTheFrontEnd and function()
    local screen = TheFrontEnd:GetActiveScreen()
    if screen.name == "ServerCreationScreen" then
        for k, v in pairs(screen.world_tabs) do
            v:Refresh()
        end
    end
end or function() end

local getnewgroupnumber = GEMWORLDGENENV.IsTheFrontEnd and function()
    local max = 0
    for k, v in pairs(GROUP) do
        max = math.max(max, v.order)
    end
    return max + 1
end or function() end

local getnewitemnumber = GEMWORLDGENENV.IsTheFrontEnd and function(GROUPNAME)
    local max = 0
    for k, v in pairs(GROUP[GROUPNAME].items) do
        max = math.max(max, v.order)
    end
    return max + 1
end or function() end

local fixgrouporder = GEMWORLDGENENV.IsTheFrontEnd and function()
    local groups = {}
    for k,v in pairs(GROUP) do
        table.insert(groups,k)
    end
    table.sort(groups, function(a,b) return GROUP[a].order < GROUP[b].order end)
    for i, groupname in ipairs(groups) do
        GROUP[groupname].order = i
    end
end or function() end

local fixitemorder = GEMWORLDGENENV.IsTheFrontEnd and function(GROUPNAME)
    local items = {}
    for k,v in pairs(GROUP[GROUPNAME].items) do
        table.insert(items, k)
    end
    table.sort(items, function(a,b) return GROUP[GROUPNAME].items[a].order < GROUP[GROUPNAME].items[b].order end)
    for i, itemname in ipairs(items) do
        GROUP[GROUPNAME].items[itemname].order = i
    end
end or function() end

fixgrouporder()
for k, v in pairs(GROUP) do
    fixitemorder(k)
end
refreshworldtabs()

function WorldGenOptions.AddGroup(GROUPNAME, groupsettings)
    if groupsettings.customtext then
        CUSTOMGROUPLABELS[GROUPNAME] = groupsettings.customtext
        groupsettings.text = groupsettings.customtext
    end
    groupsettings.order = getnewgroupnumber()
    GROUP[GROUPNAME] = groupsettings
    fixitemorder(GROUPNAME)
end

function WorldGenOptions.AddItemToGroup(GROUPNAME, ITEMNAME, itemsettings)
    itemsettings.order = getnewitemnumber(GROUPNAME)
    GROUP[GROUPNAME].items[ITEMNAME] = itemsettings
end

function WorldGenOptions.RemoveGroup(GROUPNAME)
    GROUP[GROUPNAME] = nil
    fixgrouporder()
end

function WorldGenOptions.RemoveItemFromGroup(GROUPNAME, ITEMNAME)
    GROUP[GROUPNAME].items[ITEMNAME] = nil
    fixitemorder(GROUPNAME)
end

function WorldGenOptions.ReorderGroup(GROUPNAME, TARGETGROUPNAME, moveafter)
    GROUP[GROUPNAME].order = GROUP[TARGETGROUPNAME].order + (moveafter and 0.1 or -0.1)
    fixgrouporder()
end

function WorldGenOptions.ReorderItem(GROUPNAME, ITEMNAME, TARGETITEMNAME, moveafter)
    GROUP[GROUPNAME].items[ITEMNAME].order = GROUP[GROUPNAME].items[TARGETITEMNAME].order + (moveafter and 0.1 or -0.1)
    fixitemorder(GROUPNAME)
end

local blacklist = {
    ["order"] = true,
    ["items"] = true,
}

function WorldGenOptions.SetGroupProperty(GROUPNAME, property, value)
    if not blacklist[property] then
        GROUP[GROUPNAME][property] = value
    end
end

for k, v in pairs(WorldGenOptions) do
    local _v = v
    WorldGenOptions[k] = function(...)
        local val = {_v(...)}
        refreshworldtabs()
        return unpack(val)
    end
end

function WorldGenOptions.SetItemProperty(GROUPNAME, ITEMNAME, property, value)
    if not blacklist[property] then
        GROUP[GROUPNAME].items[ITEMNAME][property] = value
    end
    if property == "alwaysedit" or property == "neveredit" then
        for _, screen_in_stack in pairs(TheFrontEnd.screenstack) do
            if screen_in_stack.name == "ServerCreationScreen" then
                for i, tab in ipairs(screen_in_stack.world_tabs) do
                    if tab.customizationlist ~= nil then
                        for k, v in pairs(tab.customizationlist.options) do
                            if v.group == GROUPNAME and v.name == ITEMNAME then
                                v[property] = value
                                break
                            end
                        end
                        tab.customizationlist.scroll_list:RefreshView()
                    end
                end 
            end
        end
    else
        refreshworldtabs()
    end
end

function WorldGenOptions.GetGroupProperty(GROUPNAME, property)
    if not blacklist[property] then
        return GROUP[GROUPNAME][property]
    end
end

function WorldGenOptions.GetItemProperty(GROUPNAME, ITEMNAME, property)
    if not blacklist[property] then
        return GROUP[GROUPNAME].items[ITEMNAME][property]
    end
end

local event_listeners = {}

function WorldGenOptions.ListenForEvent(modname, event, fn)
    if not event_listeners[modname] then
        event_listeners[modname] = {}
    end
    if not event_listeners[modname][event] then
        event_listeners[modname][event] = {}
    end
    table.insert(event_listeners[modname][event], fn)
end

function WorldGenOptions.RemoveEventCallback(modname, event, fn)
    table.removearrayvalue(event_listeners[modname] and event_listeners[modname][event] or {}, fn)
    if GetTableSize(event_listeners[modname] and event_listeners[modname][event]) == 0 then
        event_listeners[modname][event] = nil
    end
    if GetTableSize(event_listeners[modname]) == 0 then
        event_listeners[modname] = nil
    end
end

local function PushWorldGenEvent(event, ...)
    for modname, listeners in pairs(event_listeners) do
        for i, fn in ipairs(listeners[event] or {}) do
            fn(...)
        end
    end
end

WorldGenOptions.SetOptionValue = GEMWORLDGENENV.IsTheFrontEnd and function(location, option, value)
    for _, screen_in_stack in pairs(TheFrontEnd.screenstack) do
        if screen_in_stack.name == "ServerCreationScreen" then
            for i, tab in ipairs(screen_in_stack.world_tabs) do
                if location == tab:GetLocationForLevel(tab.currentmultilevel) then
                    if tab.customizationlist ~= nil then
                        tab.customizationlist:SetValueForOption(option, value)
                        tab.current_option_settings[tab.currentmultilevel].tweaks[option] = value
                    end
                end 
            end
            break
        end
    end
end or function() end

WorldGenOptions.GetOptionValue = GEMWORLDGENENV.IsTheFrontEnd and function(location, option)
    for _, screen_in_stack in pairs(TheFrontEnd.screenstack) do
        if screen_in_stack.name == "ServerCreationScreen" then
            for i, tab in ipairs(screen_in_stack.world_tabs) do
                if location == tab:GetLocationForLevel(tab.currentmultilevel) then
                    if tab.customizationlist ~= nil then
                        for i, data in pairs(tab.customizationlist.optionitems) do
                            if data.option and data.option.name == option then
                                return data.selection
                            end
                        end
                    end
                end 
            end
            break
        end
    end
end or function() return nil end

setmetatable(WorldGenOptions, {__index = function(t, k)
    if defaultdescs[k] ~= nil then
        return deepcopy(defaultdescs[k])
    end
    return nil
end,})

if GEMWORLDGENENV.IsTheFrontEnd then
    local WorldCustomizationTab = require("widgets/redux/worldcustomizationtab")
    local ServerCreationScreen = require("screens/redux/servercreationscreen")

    local CURRENT_LEVEL_LOCATIONS = SERVER_LEVEL_LOCATIONS

    local _OnBecomeActive = ServerCreationScreen.OnBecomeActive
    function ServerCreationScreen:OnBecomeActive(...)
        local retval = {_OnBecomeActive(self, ...)}
        PushWorldGenEvent("becomeactive")
        return unpack(retval)
    end

    local worldoptions

    local _AddMultiLevel = WorldCustomizationTab.AddMultiLevel
    function WorldCustomizationTab:AddMultiLevel(level, ...)
        PushWorldGenEvent("addlocation", self:GetLocationForLevel(level))
        return _AddMultiLevel(self, level, ...)
    end

    local _RemoveMultiLevel = WorldCustomizationTab.RemoveMultiLevel
    function WorldCustomizationTab:RemoveMultiLevel(level, ...)
        PushWorldGenEvent("removelocation", self:GetLocationForLevel(level))
        return _RemoveMultiLevel(self, level, ...)
    end

    local _CollectOptions = WorldCustomizationTab.CollectOptions
    function WorldCustomizationTab:CollectOptions(...)
        --incase CollectOptions is overriden multiple times
        local stacklevel = 2
        local tabidx
        while debug.getinfo(stacklevel, "n") ~= nil do
            worldoptions = LocalVariableHacker.GetLocalVariable(stacklevel, "worldoptions")
            tabidx = LocalVariableHacker.GetLocalVariable(stacklevel, "i")
            if worldoptions ~= nil and tabidx ~= nil then
                break
            end
            stacklevel = stacklevel + 1
        end
        if tabidx == GetTableSize(self.servercreationscreen.world_tabs) then
            local ret = _CollectOptions(self, ...)
            worldoptions[tabidx] = ret
            PushWorldGenEvent("postcollectoptions", worldoptions)
            return ret
        end
        return _CollectOptions(self, ...)
    end

    local _LoadPreset = WorldCustomizationTab.LoadPreset
    function WorldCustomizationTab:LoadPreset(preset, ...)
        local retvals = {_LoadPreset(self, preset, ...)}
        PushWorldGenEvent("loadpreset", preset, preset ~= nil and Levels.GetDataForLevelID(preset) or
            Levels.GetDefaultLevelData(GetLevelType(self.servercreationscreen:GetGameMode()), CURRENT_LEVEL_LOCATIONS[self.tab_location_index]) or
            Levels.GetDataForLevelID("MOD_MISSING"))
        return unpack(retvals)
    end

    local _StartSurvivalMode = SaveGameIndex.StartSurvivalMode
    function SaveGameIndex:StartSurvivalMode(...)
        worldoptions = nil
        return _StartSurvivalMode(self, ...)
    end

    local _UpdateServerData = SaveGameIndex.UpdateServerData
    function SaveGameIndex:UpdateServerData(saveslot, ...)
        if worldoptions ~= nil then
            self.data.slots[saveslot].world.options = worldoptions
            worldoptions = nil
        end
        return _UpdateServerData(self, saveslot, ...)
    end

    GEMWORLDGENENV.AddClassPostConstruct("widgets/redux/worldcustomizationlist", function(inst)
        local _spinnerCB = inst.spinnerCB
        function inst.spinnerCB(option, value, ...)
            PushWorldGenEvent("anyoptionchange", inst.location, option, value)
            PushWorldGenEvent(option.."optionchange", inst.location, value)
            return _spinnerCB(option, value, ...)
        end

        local _update_fn = inst.scroll_list.update_fn
        function inst.scroll_list.update_fn(context, widget, data, index, ...)
            local retval = {_update_fn(context, widget, data, index, ...)}
            if not data or data.is_empty then
                return
            end

            if data.heading_text then
                return
            end
            if widget.opt_spinner.data.option.neveredit then
                widget.opt_spinner.spinner:SetEditable(false)
            else
                widget.opt_spinner.spinner:SetEditable(inst.allowEdit or widget.opt_spinner.data.option.alwaysedit)
            end
            return unpack(retval)
        end
    end)
end

local do_FrontendUnloadMod
local do_FrontendLoadMod

local function my_FrontendUnloadMod(self, modname, ...)
    if modname == nil or modname == GEMWORLDGENENV.modname then
        GROUP = deepcopy(DEFAULT_GROUP)
        UpvalueHacker.SetUpvalue(Customize.ValidateOption, GROUP, "GROUP")
        refreshworldtabs()
        event_listeners = {}
        do_FrontendUnloadMod = function() end
    end
end

do_FrontendUnloadMod = my_FrontendUnloadMod

local _FrontendUnloadMod = ModManager.FrontendUnloadMod
function ModManager:FrontendUnloadMod(modname, ...)
    _FrontendUnloadMod(self, modname, ...)
    do_FrontendUnloadMod(self, modname, ...)
    event_listeners[modname or ""] = nil
end

local function my_FrontendLoadMod(self, modname, ...)
    if modname == GEMWORLDGENENV.modname then
        do_FrontendUnloadMod = my_FrontendUnloadMod
    end
end

do_FrontendLoadMod = my_FrontendLoadMod

local _FrontendLoadMod = ModManager.FrontendLoadMod
function ModManager:FrontendLoadMod(modname, ...)
    _FrontendLoadMod(self, modname, ...)
    do_FrontendLoadMod(self, modname, ...)
end

return WorldGenOptions