--[[	Copyright (c) 2015 Oscosh, Inc.	]]

local Ingredient = GLOBAL.Ingredient
local RecipeTabs = GLOBAL.RECIPETABS
local Tech = GLOBAL.TECH

GLOBAL.STRINGS.RECIPE_DESC.GEARS = "A pile of mechanical parts."

AddRecipe("gears", { Ingredient("flint", 3), Ingredient("transistor", 2) }, RecipeTabs.REFINE, Tech.SCIENCE_TWO)