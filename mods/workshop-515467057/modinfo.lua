name = "DST Faster Running"
description = "When you start running, your speed increases by 25% over 5 seconds. After you stop, your character speed starts degrading to normal over 2.5 seconds.".."\n\n".."(As a compensation Walking Cane has been disabled.)"
author = "IcyTheWhite"
forumthread = ""

version = "1.26"
api_version = 10

dst_compatible = true

client_only_mod = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"


configuration_options =
{
    {
        name = "MIN_SPEED",
        label = "Minimum Speed",
        options = {{description = "75%", data = 0.75},
                   {description = "80%", data = 0.8},
                   {description = "85%", data = 0.85},
                   {description = "90%", data = 0.9},
                   {description = "95%", data = 0.95},
                   {description = "100%", data = 1},},
        default = 1,
    },
    {
        name = "MAX_SPEED",
        label = "Maximum Speed",
        options = {{description = "100%", data = 1},
                   {description = "105%", data = 1.05},
                   {description = "110%", data = 1.1},
                   {description = "115%", data = 1.15},
                   {description = "120%", data = 1.2},
                   {description = "125%", data = 1.25},
                   {description = "130%", data = 1.3},
                   {description = "135%", data = 1.35},
                   {description = "140%", data = 1.4},
                   {description = "145%", data = 1.45},
                   {description = "150%", data = 1.5},},
        default = 1.25,
    },
    {
        name = "STEP_UP",
        label = "Increase per Second",
        options = {{description = "1%", data = 0.002},
                   {description = "2%", data = 0.004},
                   {description = "3%", data = 0.006},
                   {description = "4%", data = 0.008},
                   {description = "5%", data = 0.01},
                   {description = "10%", data = 0.02},
                   {description = "15%", data = 0.03},
                   {description = "20%", data = 0.04},
                   {description = "25%", data = 0.05},
                   {description = "50%", data = 0.1},},
        default = 0.01,
    },
    {
        name = "STEP_DOWN",
        label = "Decrease per Second",
        options = {{description = "1%", data = 0.002},
                   {description = "2%", data = 0.004},
                   {description = "5%", data = 0.01},
                   {description = "10%", data = 0.02},
                   {description = "15%", data = 0.03},
                   {description = "20%", data = 0.04},
                   {description = "25%", data = 0.05},
                   {description = "50%", data = 0.1},},
        default = 0.02,
    },
}