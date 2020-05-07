name = "Buffed Pets!"
description = "Buffed pets for everyone to enjoy! WARNING: Small and Smallish Small birds now included. Handle with care."
author = "Mister L, Fidooop and Sudura"
version = "3.0"

forumthread = "http://forums.kleientertainment.com/topic/56192-please-buff-glommer/"

api_version = 10

dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

all_clients_require_mod = true
clients_only_mod = false

server_filter_tags = {"Buff", "Glommer", "pets", "Lavae", "Chester", "Smallbirds"}

configuration_options =
    {
        {
            name = "MaxHealth",
            label = "Glommer's Max Health",
            options = {
                    {description = "default", data = 100},
                    {description = "Healthier.", data = 250},
                    {description = "Illuminati!", data = 333}, --Glommer is Illuminati confirmed!
                    {description = "BLAZE IT!", data = 420},
                    {description = "500", data = 500}, --Half a thousand!
                    {description = "1000", data = 1000}, --A thousand!
                    {description = "h4x0r.", data = 1337}, --Glomr pwn joo.
                    {description = "Goku.", data = 9001}, --Wilson, what does the scouter say about his health?
                },
            default = 100,
        },        
		{
            name = "LavaeHealth",
            label = "Lavae's Max Health",
            options = {
                    {description = "default", data = 500},
                    {description = "1000", data = 1000},
                    {description = "h4x0r.", data = 1337}, --lvae pwn joo.
                    {description = "Goku.", data = 9001},
                },
            default = 500,
        },
		{
            name = "ChesterHealth",
            label = "Chester's Max Health",
            options = {
                    {description = "default", data = 450},
                    {description = "500", data = 500}, --In case someone just wants to increase it by a pinch
                    {description = "1000", data = 1000},
                    {description = "h4x0r.", data = 1337}, --chstr pwn joo.
                    {description = "Goku.", data = 9001},
                },
            default = 450,
        },		
		{
            name = "BirdHealth",
            label = "AllBird's Max Health",
            options = {
                    {description = "default", data = 50},
                    {description = "100", data = 150},
                    {description = "250", data = 250},
                    {description = "Illuminati!", data = 333},
                    {description = "BLAZE IT!", data = 420},
                    {description = "500", data = 500},
                    {description = "1000", data = 1000},
                    {description = "h4x0r.", data = 1337},
                    {description = "Goku.", data = 9001}, --Weirdo, what does the scouter say about his health?
                },
            default = 50,
        },
        {
            name = "HealthRegen",
            label = "Glommer's H.P. Regen.",
            options = {
                    {description = "None", data = false},
                    {description = "Tofu", data = 1000}, --Super Tofu Glommer
                    {description = "Small Fry", data = 100},
                    {description = "Fast regen.", data = 50}, --Green Herb/Potion addicted.
                    {description = "Faster", data = 10}, --Glommer is strong, isn't it?
                    {description = "Fastest", data = 1}, --Health. Health? HEALTH?!?!?!
                },
            default = false,
        },        
		{
            name = "LavaeHealthRegen",
            label = "Lavae's H.P. Regen.",
            options = {
                    {description = "None", data = false},
                    {description = "Tofu", data = 1000}, --Super Tofu Lavae
                    {description = "Small Fry", data = 100},
                    {description = "Fast regen.", data = 50},
                    {description = "Faster", data = 10}, --Lavae is strong, isn't it?
                    {description = "Fastest", data = 1},
                },
            default = false,
        },
		{
            name = "ChesterHealthRegen",
            label = "Chester's H.P. Regen.",
            options = {
                    {description = "None", data = false},
                    {description = "Tofu", data = 1000}, --Super Tofu Chester
                    {description = "Small Fry", data = 100},
                    {description = "Fast regen.", data = 50},
                    {description = "Faster", data = 10},
                    {description = "Fastest", data = 1},
                },
            default = false,
        },		
		{
            name = "BirdHealthRegen",
            label = "AllBird's H.P. Regen.",
            options = {
                    {description = "None", data = false},
                    {description = "Tofu", data = 1000}, --Super Tofu birds
                    {description = "Small Fry", data = 100},
                    {description = "Fast regen.", data = 50},
                    {description = "Faster", data = 10},
                    {description = "Fastest", data = 1},
                },
            default = false,
        },
		        {
            name = "SanityAura",
            label = "Want good sanity?",
            options = {
                    {description = "default", data = 1},
                    {description = "I'm sane", data = 2},
                    {description = "Very sane", data = 3},
                    {description = "Even saner", data = 5},
                    {description = "Sanest?", data = 10},
                    {description = "I iz 2 sain", data = 100},
                },
            default = 1,
        },
		{
            name = "LavaeSanityAura",
            label = "Lavae gives sanity?",
            options = {
                    {description = "No", data = 0},
                    {description = "A little", data = 1},
                    {description = "More", data = 2},
                    {description = "Even more", data = 3},
                    {description = "MOAR", data = 5},
                    {description = "MOAR!!!", data = 10},
                    {description = "2 much", data = 100},
                },
            default = 0,
        },
		{
            name = "Voice",
            label = "Buzz buzz buzz.",
            options = {
                    {description = "Silent", data = 0}, --SILENT ALARM!
                    {description = "Harder to hear", data = 0.1}, --What you saying?
                    {description = "Hard to hear", data = 0.3}, --I caaaan't heeeaaaar yoooouuu!
                    {description = "default", data = 1},
                    {description = "ALARM!", data = 2},
                    {description = "Loud", data = 3}, --Take good care of your ears, really.
                    {description = "Louder", data = 4}, --R.I.P. headphone users...
                    {description = "LOUDER", data = 5},
                    {description = "LOUDEST?", data = 10},
                    {description = "LOUDEST!", data = 20}, --CODE RED FOR EAR BUDS!
                    {description = "Jbeetle [WARNING: LOUD]", data = 400}, --Like, super loud. Play at your own risk.
                },
            default = 1,
        },
		        {
            name = "Size",
            label = "Glommer's size.",
            options = {
                    {description = "Micro", data = 0.1}, --Makes you wanna... oh wait, where is he?
                    {description = "Small", data = 0.3}, --Teeny tiny Glommer
                    {description = "default", data = 1},
                    {description = "Teenager", data = 3},
                    {description = "Big", data = 4}, --Glommer what happened to you?
                    {description = "IT'S A GIANT!", data = 10}, --RUUUUUUUN!
                    {description = "Yeah, don't", data = 50}, --Yeap, I'm done for now. Sorry, Klei.
                },
            default = 1,
        },
		{
            name = "LavaeSize",
            label = "Lavae's size",
            options = {
                    {description = "Micro", data = 0.1},
                    {description = "Small", data = 0.3},
                    {description = "default", data = 0.75},
                    {description = "Teenager", data = 2},
                    {description = "Big", data = 3},
                    {description = "IT'S A GIANT!", data = 5},
                    {description = "Yeah, don't", data = 50},
                },
            default = 0.75,
        },
		{
            name = "ChesterSize",
            label = "Chester's size",
            options = {
                    {description = "Micro", data = 0.1},
                    {description = "Small", data = 0.3},
                    {description = "Small-ish", data = 0.7},
                    {description = "default", data = 1},
                    {description = "Teenager", data = 2},
                    {description = "Big", data = 3},
                    {description = "Bigger", data = 5},
                    {description = "IT'S A GIANT??", data = 10},
                    {description = "Yeah, don't", data = 50},
                },
            default = 1,
        },
		{
		name = "BirdSize",
            label = "AllBird's size",
            options = {
                    {description = "Micro", data = 0.1},
                    {description = "Small", data = 0.2},
                    {description = "Small-ish", data = 0.4},
                    {description = "default", data = 0.6},
                    {description = "Teenager", data = 2},
                    {description = "Big", data = 3},
                    {description = "IT'S A GIANT!", data = 5},
                    {description = "Yeah, don't", data = 50},
                },
            default = 0.6,
        },
		{
            name = "Speed",
            label = "SPEED IS KEY!",
            options = {
                    {description = "default", data = 6},
                    {description = "Kinda fast", data = 7},
                    {description = "Fast", data = 8},
                    {description = "Faster", data = 10},
                    {description = "Fastest?", data = 50},
                    {description = "SANIC!", data = 100},
                },
            default = 6,
        },
		{
            name = "LavaeSpeed",
            label = "OH NO! SPEEDY LAVA!",
            options = {
                    {description = "default", data = 7.5},
                    {description = "Fast", data = 10},
                    {description = "Faster", data = 30},
                    {description = "Fastest?", data = 50},
                    {description = "SANIC!", data = 100},
                },
            default = 7.5,
        },
		{
            name = "ChesterSpeed",
            label = "A running chest!",
            options = {
                    {description = "default", data = 7.5},
                    {description = "Fast", data = 10},
                    {description = "Faster", data = 30},
                    {description = "Fastest?", data = 50},
                    {description = "SANIC!", data = 100},
                },
            default = 7.5,
        },		
		{
            name = "BirdSpeed",
            label = "RUN, BIRD! RUN!",
            options = {
                    {description = "default", data = 4},
                    {description = "Fast", data = 10},
                    {description = "Faster", data = 30},
                    {description = "Fastest?", data = 50},
                    {description = "SANIC!", data = 100},
                },
            default = 6,
        },
		{
            name = "LavaeRadius",
            label = "Lavae's light radius",
            options = {
                    {description = "default", data = 1},
                    {description = "big-ish", data = 2},
                    {description = "Kinda big", data = 3},
                    {description = "Big", data = 5},
                    {description = "Bigger", data = 10},
                    {description = "Even bigger", data = 30},
                    {description = "A lot bigger", data = 50},
                    {description = "Biggest?", data = 80},
                    {description = "BIGGY", data = 100},
                    {description = "BIGGEST?", data = 500},
                    {description = "2 big 5 me", data = 1000},
                },
            default = 1,
        },
		{
            name = "LightIntensity",
            label = "Lavae's Light Intensity",
            options = {
                    {description = "default", data = 0.75},
                    {description = "More light", data = 3},
                    {description = "MORE light", data = 5},
                    {description = "even more light", data = 10},
                    {description = "Handful of light", data = 30},
                    {description = "Lots of light", data = 50},
                    {description = "2 much light", data = 100},
                },
            default = 0.75,
        },
		{
            name = "LavaeHunger",
            label = "Lavae's Hunger",
            options = {
                    {description = "Yes", data = 50},
                    {description = "No", data = 0},
                },
            default = 50,
        },		
		{
            name = "BirdHunger",
            label = "Smallbird's Hunger",
            options = {
                    {description = "Yes", data = 20},
                    {description = "No", data = 0},
                },
            default = 20,
        },
		{
            name = "FirePropagator",
            label = "Lavae's fire",
            options = {
                    {description = "Yes", data = true},
                    {description = "No", data = false},
                },
            default = true,
        },		
		{
            name = "BirdAttack",
            label = "AllBird's attack!",
            options = {
                    {description = "Default", data = 10},
                    {description = "Good", data = 20},
                    {description = "Gooder", data = 50},
                    {description = "Better", data = 100},
                    {description = "Best?", data = 500},
                    {description = "Best!", data = 1000},
                },
            default = 10,
        },
    }