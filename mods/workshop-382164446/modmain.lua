STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH

PrefabFiles = {}

GLOBAL.GetNightmareClock = function () return nil end
GLOBAL.STRINGS.NAMES.ANCIENT_ALTAR_ITEM = "Ancient Altar"
STRINGS.RECIPE_DESC.ANCIENT_ALTAR_ITEM = "Allows a new category of crafting."
		
local ancient_altar_item = GLOBAL.Recipe("ancient_altar", {Ingredient("purplegem", 2),Ingredient("nightmarefuel", 3),Ingredient("cutstone", 5)}, RECIPETABS.MAGIC, TECH.MAGIC_TWO)
