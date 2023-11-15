Config = {}

Config.DebugCode = false

Config.Webhooks = {
    Enable = false,
    URL = 'changeme',
}

Config.CustomMenu = {
    InventoryLink = 'qb-inventory/html/images/',
    HideLockedItems = true, --hides items you havent reached the level for(false shows them but wont let you craft them)
    ShowLevelRequired = false, --only works if HideLockedItems = false
}

--[[Config Variables = {
    LVLUnlocked - can be used on all crafting types (props/locations/peds). this just means you need to certain level to use this spot
    CraftingTable - You must include this as it ties the spot to a table in Config.CraftingTable
    CraftEmote - must be included as this determines what emote you do as this location

    JobLocked - whether to lock location to a job
    GangLocked - whether to lock location to a gang
    ItemLocked - whether to lock location to a specific item(must be in inventory)
    CIDLocked - locks location to a specific character
    
    SpeechRecognise - enables 17Mov's speech recognition system
} ]]
Config.CraftProps = { --enables targetting certain props to access crafting
    { --table starts here
        Enable = true, -- enabled/disable these set of props
        LVLUnlocked = 5, --can be level number or (false or just remove the line)
        Props = {
            {prop = `prop_arm_wrestle_01`,}, --never use the same prop twice as it will stop the script working as intended
            {prop = `gr_prop_gr_bench_04a`,},
            {prop = `imp_prop_impexp_mechbench`,},
            {prop = `prop_tool_bench02_ld`,},
        },
        CraftingTable = 'basic', --the table that is used from Config.CraftingTable
        CraftEmote = 'mechanic', --emote that is used when crafting from spot
    }, --table ends here
    {
        Enable = false,
        Props = {
            {prop = `prop_toolchest_05`,},
        },
        CraftingTable = 'police',
        JobLocked = 'police',
        CraftEmote = 'mechanic',
    },
}

Config.SpawnCraftProps = { --spawns a prop to be used as a crafting table
    { 
        Enable = true, -- enabled/disable these set of props
        LVLUnlocked = 1, --can be level number or (false or just remove the line)
        prop = `bkr_prop_coke_table01a`, -- the prop you want to spawn
        Locations = { --the locations to spawn them in
            {Coords = vector3(0,0,0)}, --changeme
            
        },
        CraftingTable = 'basic', --the table that is used from Config.CraftingTable
        CraftEmote = 'mechanic', --emote that is used when crafting from spot
    }, --table ends here
}

Config.CraftLocations = { --enables a boxzone location to target and access crafting
    {
        Enable = true,
        Locations = {
            {Label = "Crafting",Coords = vector3(606.52, -3087.7, 6.07), Heading = 0,},
        },
        CraftingTable = 'basic',
        CraftEmote = 'mechanic',
    },
    {
        Enable = true,
        Locations = {
            {Label = "Crafting",Coords = vector3(458.1, -979.08, 30.69), Heading = 0,},
        },
        CraftingTable = 'police',
        CraftEmote = 'mechanic',
        JobLocked = 'police',
    },
}

Config.PedOptions = { --ped options for the Config.CraftPeds table
    ['MinusOne'] = true,
    ['Freeze'] = true,
    ['Invincible'] = true,
    ['IgnoreEvents'] = true,
}
Config.CraftPeds = {  --spawns peds that let you access the crafting (if you do not wish to use change Peds = {} to Peds = false)
    {
        Enable = true,
        Peds = {
            {
                Model = 'a_f_m_business_02',
                Coords = vector4(332.55, -213.72, 54.08, 57.74),
                Label = "Trading",
            },
            -- {
            --     Model = 'a_m_m_eastsa_02',
            --     Coords = vector4(335.43, -213.77, 54.09, 69.51),
            --     Label = "Trading",
            --     SpeechRecognise = {
            --         {Phrase = {"test crafting",},BlockInVehicle = true,AllowRecognitionInReverse = false},
            --     },
            -- },
        },
        CraftingTable = 'basic',
        CraftEmote = 'argue',
    },
}

Config.CraftItems = { --makes items useable (first variable is the itemcode)
    ['toolbox'] = {CraftingTable = 'toolbox',JobLocked = 'mechanic',CraftEmote = 'mechanic4',}, --this is an example.
}

Config.CraftingTable = {
    ['basic'] = {
        Label = "Crafting",
        Items = {
            [1] = {
                ItemCode = 'lockpick', --item you will craft
                Amount = 1, --amount you receive
                CraftTime = 5, --how many Seconds to craft
                LVLNeeded = 1, --level needed
                XPGain = 1, --how much xp to gain from successful craft
                SuccessChance = 70, --(%) chance of success
                Recipe = {
                    [1] = {item = 'metalscrap',amount = 1,},
                    [2] = {item = 'plastic',amount = 1,},
                },
            },
            [2] = {
                ItemCode = 'screwdriverset',
                Amount = 1,
                CraftTime = 10,
                LVLNeeded = 1,
                XPGain = 1,
                SuccessChance = 70,
                Recipe = {
                    [1] = {item = 'metalscrap',amount = 1,},
                    [2] = {item = 'plastic',amount = 1,},
                },
            },
            [3] = {
                ItemCode = 'electronickit',
                Amount = 1,
                CraftTime = 10,
                LVLNeeded = 1,
                XPGain = 1,
                SuccessChance = 70,
                Recipe = {
                    [1] = {item = 'metalscrap',amount = 1,},
                    [2] = {item = 'plastic',amount = 1,},
                    [3] = {item = 'aluminum',amount = 1,},
                },
            },
            [4] = {
                ItemCode = 'radioscanner',
                Amount = 1,
                CraftTime = 10,
                LVLNeeded = 1,
                XPGain = 1,
                SuccessChance = 70,
                Recipe = {
                    [1] = {item = 'electronickit',amount = 1,},
                    [2] = {item = 'plastic',amount = 1,},
                    [3] = {item = 'steel',amount = 1,},
                },
            },
            [5] = {
                ItemCode = 'gatecrack',
                Amount = 1,
                CraftTime = 10,
                LVLNeeded = 1,
                XPGain = 1,
                SuccessChance = 70,
                Recipe = {
                    [1] = {item = 'metalscrap',amount = 1,},
                    [2] = {item = 'plastic',amount = 1,},
                    [3] = {item = 'aluminum',amount = 1,},
                    [4] = {item = 'iron',amount = 1,},
                    [5] = {item = 'electronickit',amount = 1,},
                },
            },
            [6] = {
                ItemCode = 'drill',
                Amount = 1,
                CraftTime = 10,
                LVLNeeded = 1,
                XPGain = 1,
                SuccessChance = 70,
                Recipe = {
                    [1] = {item = 'metalscrap',amount = 1,},
                    [2] = {item = 'plastic',amount = 1,},
                    [3] = {item = 'screwdriverset',amount = 1,},
                    [4] = {item = 'iron',amount = 1,},
                    [5] = {item = 'electronickit',amount = 1,},
                },
            },
        },
    },
    ['toolbox'] = {
        Label = "Toolbox",
        Items = {
            [1] = {
                ItemCode = 'tunerlaptop', 
                Amount = 1, 
                CraftTime = 5, 
                LVLNeeded = 1, 
                XPGain = 1, 
                SuccessChance = 70, 
                Recipe = {
                    [1] = {item = 'electronickit',amount = 1,},
                    [2] = {item = 'plastic',amount = 2,},
                },
            },
            [2] = {
                ItemCode = 'repairkit',
                Amount = 1,
                CraftTime = 10,
                LVLNeeded = 5,
                XPGain = 25,
                SuccessChance = 10,
                Recipe = {
                    [1] = {item = 'iron',amount = 5,},
                    [2] = {item = 'steel',amount = 10,},
                    [3] = {item = 'metalscrap',amount = 2,},
                },
            },
        },
    },
    ['attatchments'] = {
        Label = "Attatchments",
        Items = {
            [1] = {
                ItemCode = 'pistol_extendedclip', 
                Amount = 1, 
                CraftTime = 5, 
                LVLNeeded = 1, 
                XPGain = 1, 
                SuccessChance = 70, 
                Recipe = {
                    [1] = {item = 'metalscrap',amount = 1,},
                    [2] = {item = 'steel',amount = 1,},
                    [3] = {item = 'rubber',amount = 1,},
                },
            },
            [2] = {
                ItemCode = 'pistol_suppressor',
                Amount = 1,
                CraftTime = 10,
                LVLNeeded = 5,
                XPGain = 1,
                SuccessChance = 70,
                Recipe = {
                    [1] = {item = 'iron',amount = 1,},
                    [2] = {item = 'steel',amount = 1,},
                    [3] = {item = 'metalscrap',amount = 1,},
                },
            },
        },
    },
    ['police'] = {
        Label = "Police",
        Items = {
            [1] = {
                ItemCode = 'armor', 
                Amount = 1, 
                CraftTime = 5, 
                LVLNeeded = 1, 
                XPGain = 1, 
                SuccessChance = 70, 
                Recipe = {
                    [1] = {item = 'rubber',amount = 1,},
                },
            },
            [2] = {
                ItemCode = 'heavyarmor', 
                Amount = 1, 
                CraftTime = 5, 
                LVLNeeded = 1, 
                XPGain = 1, 
                SuccessChance = 70, 
                Recipe = {
                    [1] = {item = 'rubber',amount = 1,},
                },
            },
            [3] = {
                ItemCode = 'handcuffs', 
                Amount = 1, 
                CraftTime = 5, 
                LVLNeeded = 1, 
                XPGain = 1, 
                SuccessChance = 70, 
                Recipe = {
                    [1] = {item = 'steel',amount = 1,},
                },
            },
            [4] = {
                ItemCode = 'police_stormram', 
                Amount = 1, 
                CraftTime = 5, 
                LVLNeeded = 1, 
                XPGain = 1, 
                SuccessChance = 70, 
                Recipe = {
                    [1] = {item = 'steel',amount = 1,},
                },
            },
            [5] = {
                ItemCode = 'empty_evidence_bag', 
                Amount = 1, 
                CraftTime = 5, 
                LVLNeeded = 1, 
                XPGain = 1, 
                SuccessChance = 70, 
                Recipe = {
                    [1] = {item = 'plastic',amount = 1,},
                },
            },
        },
    }
}

Config.Recycle = { --working
    ['lockpick'] = {
        [1] = {item = 'iron',Min = 1,Max = 3},
        [2] = {item = 'steel',Min = 1,Max = 3},
    },
    ['car_tyre'] = {
        [1] = {item = 'rubber',Min = 1,Max = 3},
    },
}
Config.RecycleTime = 10
Config.RecycleSuccessChance = 50


Config.Levels = {
    [1] = {NextLevel = 100},
    [2] = {NextLevel = 200},
    [3] = {NextLevel = 300},
    [4] = {NextLevel = 400},
    [5] = {NextLevel = 500},
    [6] = {NextLevel = 600},
    [7] = {NextLevel = 700},
    [8] = {NextLevel = 800},
    [9] = {NextLevel = 900},
    [10] = {NextLevel = 1000},
    [11] = {NextLevel = 1100},
    [12] = {NextLevel = 1200},
    [13] = {NextLevel = 1300},
    [14] = {NextLevel = 1400},
    [15] = {NextLevel = 1500},
    [16] = {NextLevel = 1600},
    [17] = {NextLevel = 1700},
    [18] = {NextLevel = 1800},
    [19] = {NextLevel = 1900},
    [20] = {NextLevel = 2000},
    [21] = {NextLevel = 2100},
    [22] = {NextLevel = 2200},
    [23] = {NextLevel = 2300},
    [24] = {NextLevel = 2400},
    [25] = {NextLevel = 2500},
    [26] = {NextLevel = 2600},
    [27] = {NextLevel = 2700},
    [28] = {NextLevel = 2800},
    [29] = {NextLevel = 2900},
    [30] = {NextLevel = 3000},
    [31] = {NextLevel = 3100},
    [32] = {NextLevel = 3200},
    [33] = {NextLevel = 3300},
    [34] = {NextLevel = 3400},
    [35] = {NextLevel = 3500},
    [36] = {NextLevel = 3600},
    [37] = {NextLevel = 3700},
    [38] = {NextLevel = 3800},
    [39] = {NextLevel = 3900},
    [40] = {NextLevel = 4000},
    [41] = {NextLevel = 4100},
    [42] = {NextLevel = 4200},
    [43] = {NextLevel = 4300},
    [44] = {NextLevel = 4400},
    [45] = {NextLevel = 4500},
    [46] = {NextLevel = 4600},
    [47] = {NextLevel = 4700},
    [48] = {NextLevel = 4800},
    [49] = {NextLevel = 4900},
    [50] = {NextLevel = 5000},
    [51] = {NextLevel = 5100},
    [52] = {NextLevel = 5200},
    [53] = {NextLevel = 5300},
    [54] = {NextLevel = 5400},
    [55] = {NextLevel = 5500},
    [56] = {NextLevel = 5600},
    [57] = {NextLevel = 5700},
    [58] = {NextLevel = 5800},
    [59] = {NextLevel = 5900},
    [60] = {NextLevel = 6000},
    [61] = {NextLevel = 6100},
    [62] = {NextLevel = 6200},
    [63] = {NextLevel = 6300},
    [64] = {NextLevel = 6400},
    [65] = {NextLevel = 6500},
    [66] = {NextLevel = 6600},
    [67] = {NextLevel = 6700},
    [68] = {NextLevel = 6800},
    [69] = {NextLevel = 6900},
    [70] = {NextLevel = 7000},
    [71] = {NextLevel = 7100},
    [72] = {NextLevel = 7200},
    [73] = {NextLevel = 7300},
    [74] = {NextLevel = 7400},
    [75] = {NextLevel = 7500},
    [76] = {NextLevel = 7600},
    [77] = {NextLevel = 7700},
    [78] = {NextLevel = 7800},
    [79] = {NextLevel = 7900},
    [80] = {NextLevel = 8000},
    [81] = {NextLevel = 8100},
    [82] = {NextLevel = 8200},
    [83] = {NextLevel = 8300},
    [84] = {NextLevel = 8400},
    [85] = {NextLevel = 8500},
    [86] = {NextLevel = 8600},
    [87] = {NextLevel = 8700},
    [88] = {NextLevel = 8800},
    [89] = {NextLevel = 8900},
    [90] = {NextLevel = 9000},
    [91] = {NextLevel = 9100},
    [92] = {NextLevel = 9200},
    [93] = {NextLevel = 9300},
    [94] = {NextLevel = 9400},
    [95] = {NextLevel = 9500},
    [96] = {NextLevel = 9600},
    [97] = {NextLevel = 9700},
    [98] = {NextLevel = 9800},
    [99] = {NextLevel = 9900},
    [100] = {NextLevel = 0},
}