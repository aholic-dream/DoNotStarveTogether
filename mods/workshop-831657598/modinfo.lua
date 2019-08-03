
name = "Stacks Size"
description = "Increase your stacks!\nAlso possible to reduce the stacks, if you want hard-play.\n\nУвеличьте свои стаки!\nТакже можно уменьшить количество стаков, если вы хотите тяжелой игры."

author = "Tesumoto"

version = "2.4"

forumthread = ""

api_version = 10

dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true

all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
	{
	name = "stack_size",
	label = "Размер стаков",
	hover = "Stacks size",
	options =	{
		{description = "x0.1", data = 1, hover = "Small, Medium and Large 4/2/1 items in stack"},
		{description = "x0.2", data = 2, hover = "Small, Medium and Large 8/4/2 items in stack"},
		{description = "x0.3", data = 3, hover = "Small, Medium and Large 12/6/3 items in stack"},
		{description = "x0.4", data = 4, hover = "Small, Medium and Large 16/8/4 items in stack"},
		{description = "x0.5", data = 5, hover = "Small, Medium and Large 20/10/5 items in stack"},
		{description = "x0.6", data = 6, hover = "Small, Medium and Large 24/12/6 items in stack"},
		{description = "x0.7", data = 7, hover = "Small, Medium and Large 28/14/7 items in stack"},
		{description = "x0.8", data = 8, hover = "Small, Medium and Large 32/16/8 items in stack"},
		{description = "x0.9", data = 9, hover = "Small, Medium and Large 36/18/9 items in stack"},
		{description = "x1", data = 10, hover = "Small, Medium and Large 40/20/10 items in stack"},
		{description = "x1.1", data = 11, hover = "Small, Medium and Large 44/22/11 items in stack"},
		{description = "x1.2", data = 12, hover = "Small, Medium and Large 48/24/12 items in stack"},
		{description = "x1.3", data = 13, hover = "Small, Medium and Large 52/26/13 items in stack"},
		{description = "x1.4", data = 14, hover = "Small, Medium and Large 56/28/14 items in stack"},
		{description = "x1.5", data = 15, hover = "Small, Medium and Large 60/30/15 items in stack"},
		{description = "x1.6", data = 16, hover = "Small, Medium and Large 64/32/16 items in stack"},
		{description = "x1.7", data = 17, hover = "Small, Medium and Large 68/34/17 items in stack"},
		{description = "x1.8", data = 18, hover = "Small, Medium and Large 72/36/18 items in stack"},
		{description = "x1.9", data = 19, hover = "Small, Medium and Large 76/38/19 items in stack"},
		{description = "x2", data = 20, hover = "Small, Medium and Large 80/40/20 items in stack"},
		{description = "x3", data = 30, hover = "Small, Medium and Large 120/60/30 items in stack"},
				},
	default = 10,
	},
}