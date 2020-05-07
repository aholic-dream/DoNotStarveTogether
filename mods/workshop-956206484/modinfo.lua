name = "Show Nicknames"
local russian = name.utf8len and (russian or language == "ru")
description = russian and "Показать ники игроков." or "Show nicknames over players."
forumthread = ""
author = "star"

version =            "1.01"
version_compatible = "1.00"

api_version = 10
dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true
all_clients_require_mod = false
client_only_mod = true
server_filter_tags = {}

priority = 0.123

icon_atlas = "preview.xml"
icon = "preview.tex"

configuration_options =
{
    {
        name = "show_oneself",
        label = "Show Oneself",
		hover = "Show your nickname of your character.",
        options = 
        {
            {description = "Yes", data = true},
            {description = "No", data = false},
        }, 
        default = true,
    },
}
