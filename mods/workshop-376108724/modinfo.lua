name = "Loot-Chance Modifier"

description = "Make the dropchance of various mobs adjustable in Mod-Configuration"

author = "ChaosMind42"

version = "1.4"

api_version = 10

dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true

forumthread = ""

all_clients_require_mod = true
clients_only_mod = false

server_filter_tags = {"utility"}
configuration_options =
{
	{
		name = "KRAMPUSSACKLOOTCHANCE",
		label = "Chance for Krampus-Sack",
		options =	{
						{description = "1%", data = 1},
						{description = "2%", data = 2},
						{description = "3%", data = 3},
						{description = "4%", data = 4},
						{description = "5%", data = 5},
						{description = "6%", data = 6},
						{description = "7%", data = 7},
						{description = "8%", data = 8},
						{description = "9%", data = 9},
                  {description = "10%", data = 10},
                  {description = "15%", data = 15},
                  {description = "25%", data = 25},
                  {description = "35%", data = 35},
                  {description = "50%", data = 50},
                  {description = "75%", data = 75},
                  {description = "100%", data = 100},
					},
		default = 10,
	},
   {
		name = "PIGLOOT",
		label = "Pigs (skin/meat)",
		options =	{
						{description = "lots", data = 1},
						{description = "more", data = 2},
						{description = "default", data = 3},
						{description = "less", data = 4},
					},
		default = 2,
	},
   {
		name = "BUTTERFLYLOOT",
		label = "Butterfly (butter/wings)",
		options ={
						{description = "lots", data = 1},
						{description = "more", data = 2},
						{description = "default", data = 3},
						{description = "less", data = 4},
					},
		default = 2,
	},
   {
		name = "WALRUSHATCHANCE",
		label = "Chance for tam o shanter",
		options ={
						{description = "1%", data = 1},
						{description = "2%", data = 2},
						{description = "3%", data = 3},
						{description = "4%", data = 4},
						{description = "5%", data = 5},
						{description = "6%", data = 6},
						{description = "7%", data = 7},
						{description = "8%", data = 8},
						{description = "9%", data = 9},
                  {description = "10%", data = 10},
                  {description = "15%", data = 15},
                  {description = "25%", data = 25},
                  {description = "35%", data = 35},
                  {description = "50%", data = 50},
                  {description = "75%", data = 75},
                  {description = "100%", data = 100},
					},
		default = 25,
	},
   {
		name = "WALRUSTUSKCHANCE",
		label = "Chance for walrus tusk",
		options ={
						{description = "1%", data = 1},
						{description = "2%", data = 2},
						{description = "3%", data = 3},
						{description = "4%", data = 4},
						{description = "5%", data = 5},
						{description = "6%", data = 6},
						{description = "7%", data = 7},
						{description = "8%", data = 8},
						{description = "9%", data = 9},
                  {description = "10%", data = 10},
                  {description = "15%", data = 15},
                  {description = "25%", data = 25},
                  {description = "35%", data = 35},
                  {description = "50%", data = 50},
                  {description = "75%", data = 75},
                  {description = "100%", data = 100},
					},
		default = 50,
	},
}

priority = 0.00376108724