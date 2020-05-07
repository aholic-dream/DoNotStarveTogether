name = "ActionQueue(DST)"
id = "action.queue"
version = "1.3.6"
author = "simplex"
forumthread = ""

description = "Original author: simplex. I update it for the DST.Maybe it works without movement prediction now.Thanks rezecib's help."..
"\nSupport auto repeat make item by shift + click(default enable,can disable in config)\n按住SHIFT点击制作 可自动重复制作物品(默认开启，可修改配置关闭)"..
"\nchange mod config to enable auto collect\nMOD中配置可激活自动拾取\nSupport auto plant,deploy by shift + right click\nSHIFT+右键自动种植,建墙"..
"\nAllows queueing a sequence of actions (such as chopping, mining, etc.) by selecting targets within a bounding box, holding SHIFT.\nSHIFT+按住左右键框选可执行重复性工作"

local icon_stem = "modicon"

api_version = 6
api_version_dst = 10

dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true

all_clients_require_mod = false
client_only_mod = true

configuration_options = {
	-- {
 --        name = "isNewDstVersion",
 --        label = "New DST Version?",
 --        options = 
 --        {
 --            {description = "yes", data = "yes"},
 --            {description = "no", data = "no"},
 --        },
 --        default = "yes"
 --    },
    {
        name = "autoCollect",
        label = "Auto Collect",
        options = 
        {
            {description = "yes", data = "yes"},
            {description = "no", data = "no"},
        },
        default = "no"
    },
    {
        name = "repeatMake",
        label = "Repeat Make",
        options = 
        {
            {description = "yes", data = "yes"},
            {description = "no", data = "no"},
        },
        default = "yes"
    },
    {
        name = "aqKey",
        label = "key instead of shift",
        options = 
        {
            {description = "SHIFT", data = "SHIFT"},
            {description = "ALT", data = "ALT"},
            {description = "Z", data = "Z"},
            {description = "X", data = "X"},
            {description = "C", data = "C"},
            {description = "V", data = "V"},
            {description = "B", data = "B"},
        },
        default = "SHIFT"
    },
}

if icon_stem then
	icon = icon_stem .. ".tex"
	icon_atlas = icon_stem .. ".xml"
end

return icon_stem


