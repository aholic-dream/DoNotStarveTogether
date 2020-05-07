name = "几何种植(改)"
description = "客机也可使用几何种植，取自http://steamcommunity.com/sharedfiles/filedetails/?id=351325790"
author = "Ctyise"
version = "1.1.1"
api_version = 10
api_version_dst = 10

priority = -10

all_clients_require_mod = true
client_only_mod = false
dst_compatible = true

icon_atlas = "geometricplacement.xml"
icon = "geometricplacement.tex"

server_filter_tags = {}

local smallgridsizeoptions = {}
for i=1,10 do smallgridsizeoptions[i] = {description=""..(i*2).."", data=i*2} end
local medgridsizeoptions = {}
for i=1,10 do medgridsizeoptions[i] = {description=""..(i).."", data=i} end
local floodgridsizeoptions = {}
for i=1,10 do floodgridsizeoptions[i] = {description=""..(i).."", data=i} end
local biggridsizeoptions = {}
for i=1,5 do biggridsizeoptions[i] = {description=""..(i).."", data=i} end

local KEY_A = 65
local keyslist = {}
local string = "" -- can't believe I have to do this... -____-
for i = 1, 26 do
	local ch = string.char(KEY_A + i - 1)
	keyslist[i] = {description = ch, data = ch}
end

local percent_options = {}
for i = 1, 10 do
	percent_options[i] = {description = i.."0%", data = i/10}
end
percent_options[11] = {description = "Unlimited", data = false}

configuration_options =
{
	{
		name = "CTRL",
		label = "CTRL Turns Mod",
		options =	{
						{description = "On", data = true},
						{description = "Off", data = false},
					},
		default = false,
		hover = "Whether holding CTRL enables or disables the mod.",
	},
    {
        name = "KEYBOARDTOGGLEKEY",
        label = "Options Button",
        options = keyslist,
        default = "B",
		hover = "A key to open the mod's options. On controllers, open\nthe scoreboard and then use Menu Misc 3 (left stick click).\nI recommend setting this with the Settings menu in DST.",
    },    
    {
        name = "GEOMETRYTOGGLEKEY",
        label = "Toggle Button",
        options = keyslist,
        default = "V",
		hover = "A key to toggle to the most recently used geometry\n(for example, switching between Square and X-Hexagon)\nI recommend setting this with the Settings menu in DST.",
    },    
    {
        name = "SHOWMENU",
        label = "In-Game Menu",
		options =	{
						{description = "On", data = true},
						{description = "Off", data = false},
					},
        default = true,
		hover = "If on, the button opens the menu.\nIf off, it just toggles the mod on and off.",
    },    
	{
		name = "BUILDGRID",
		label = "Show Build Grid",
		options =	{
						{description = "On", data = true},
						{description = "Off", data = false},
					},
		default = true,	
		hover = "Whether to show the build grid.",
	},
	{
		name = "GEOMETRY",
		label = "Grid Geometry",
		options =	{
						{description = "Square", data = "SQUARE"},
						{description = "Diamond", data = "DIAMOND"},
						{description = "X Hexagon", data = "X_HEXAGON"},
						{description = "Z Hexagon", data = "Z_HEXAGON"},
						{description = "Flat Hexagon", data = "FLAT_HEXAGON"},
						{description = "Pointy Hexagon", data = "POINTY_HEXAGON"},
					},
		default = "SQUARE",	
		hover = "What build grid geometry to use.",
	},
	{
		name = "TIMEBUDGET",
		label = "Refresh Speed",
		options = percent_options,
		default = 0.1,	
		hover = "How much of the available time to use for refreshing the grid.\nDisabling or setting too high will likely cause lag.",
	},
	{
		name = "HIDEPLACER",
		label = "Hide Placer",
		options =	{
						{description = "On", data = true},
						{description = "Off", data = false},
					},
		default = false,	
		hover = "Whether to hide the placer (the ghost version of the item you're placing).\nHiding it can help you see the grid better.",
	},
	{
		name = "HIDECURSOR",
		label = "Hide Cursor Item",
		options =	{
						{description = "Hide All", data = 1},
						{description = "Show Number", data = true},
						{description = "Show All", data = false},
					},
		default = false,	
		hover = "Whether to hide the cursor item, to better see the grid.",
	},
	{
		name = "SMALLGRIDSIZE",
		label = "Fine Grid Size",
		options = smallgridsizeoptions,
		default = 10,	
		hover = "How big to make the grid for things that use a fine grid (structures, plants, etc).",
	},
	{
		name = "MEDGRIDSIZE",
		label = "Wall Grid Size",
		options = medgridsizeoptions,
		default = 6,	
		hover = "How big to make the grid for walls.",
	},
	{
		name = "FLOODGRIDSIZE",
		label = "Sandbag Grid Size",
		options = floodgridsizeoptions,
		default = 5,	
		hover = "How big to make the grid for sandbags.",
	},
	{
		name = "BIGGRIDSIZE",
		label = "Turf Grid Size",
		options = biggridsizeoptions,
		default = 2,	
		hover = "How big to make the grid for turf/pitchfork.",
	},
	{
		name = "COLORS",
		label = "Grid Colors",
		options =	{
						{description = "Red/Green", data = "redgreen", hover = "The standard red and green that the normal game uses."},
						{description = "Red/Blue", data = "redblue", hover = "Substitutes blue in place of the green,\nhelpful for the red/green colorblind."},
						{description = "Black/White", data = "blackwhite", hover = "Black for blocked and white for placeable,\nusually more visible."},
						{description = "Outlined", data = "blackwhiteoutline", hover = "Black and white, but with outlines for improved visibility."},
					},
		default = "blackwhiteoutline",	
		hover = "Alternate color schemes for the grid and placer, for improved visibility.",
	},
	{
		name = "REDUCECHESTSPACING",
		label = "Tighter Chests",
		options =	{
						{description = "Yes", data = true},
						{description = "No", data = false},
					},
		default = true,	
		hover = "Whether to allow chests to be placed closer together than normal.\nThis may not work in DST.",
	},
	{
		name = "CONTROLLEROFFSET",
		label = "Controller Offset",
		options =	{
						{description = "On", data = true},
						{description = "Off", data = false},
					},
		default = false,	
		hover = "With a controller, whether objects get placed\nright at your feet (\"off\") or at an offset (\"on\").",
	},
	{
		name = "HIDEBLOCKED",
		label = "Hide Blocked Points",
		options =	{
						{description = "On", data = true},
						{description = "Off", data = false},
					},
		default = false,	
		hover = "Instead of showing red/black points for blocked locations, simply hides the points instead.",
	},
	{
		name = "SHOWTILE",
		label = "Show Nearest Tile",
		options =	{
						{description = "On", data = true},
						{description = "Off", data = false},
					},
		default = false,	
		hover = "When placing anything, shows the outline of the nearest tile.",
	},
}