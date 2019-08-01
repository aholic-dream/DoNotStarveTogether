name = " 行为排队论(DST)"
id = "action.queue"
version = "1.3.7"
author = "simplex Shang"
forumthread = ""

description = "当前版本："..version.."\n原作者:simplex 我做了小木牌的排队论，由于无法联系原作者，只好自己更新，如有侵权随时下架。"..
"\n按住SHIFT点击制作 可自动重复制作物品(默认开启，可修改配置关闭)"..
"\nMOD中配置可激活自动拾取\nSHIFT+右键自动种植,建墙"..
"\nSHIFT+按住左右键框选可执行重复性工作"

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
        label = "自动收集",
        options = 
        {
            {description = "是", data = "yes"},
            {description = "否", data = "no"},
        },
        default = "no"
    },
    {
        name = "repeatMake",
        label = "重复制作",
        options = 
        {
            {description = "是", data = "yes"},
            {description = "否", data = "no"},
        },
        default = "yes"
    },
    {
        name = "aqKey",
        label = "更改按键默认Shift",
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


