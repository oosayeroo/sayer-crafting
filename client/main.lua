local QBCore = exports['qb-core']:GetCoreObject()

isLoggedIn = true
PlayerJob = {}
local SpawnTargetProp = {}
local TargetProp = {}
local TargetLoc = {}
local TargetPed = {}
local Speech = {}
local onDuty = true
local IsBusy = false

AddEventHandler('onResourceStart', function(resource) 
    if GetCurrentResourceName() ~= resource then return end
	QBCore.Functions.GetPlayerData(function(PlayerData)
		PlayerLVL = PlayerData.metadata['sayercraftlevel']
	end)
    --EnableTargetShit()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerIdentifier = QBCore.Functions.GetPlayerData().citizenid
    local level = QBCore.Functions.GetPlayerData().metadata["sayercraftlevel"]
    local xp = QBCore.Functions.GetPlayerData().metadata["sayercraftxp"]
    local max = #Config.Levels
    local Next = Config.Levels[level].NextLevel

    if level > max then
        TriggerServerEvent('sayer-crafting:SetLevel',max)
    end
    if xp > Next then
        TriggerServerEvent('sayer-crafting:SetXP',0)
    end
    EnableTargetShit()
end)

function EnableTargetShit()
    CreateThread(function()
        local Player = QBCore.Functions.GetPlayerData()
        local PlayerLVL = Player.metadata['sayercraftlevel']
        for k,v in pairs(Config.CraftProps) do
            if v.Enable then
                if v.LVLUnlocked then
                    if PlayerLVL >= v.LVLUnlocked then
                        if v.Props then
                            for d,j in pairs(v.Props) do
                                TargetProp['CraftProp'..k..d] = 
                                exports['qb-target']:AddTargetModel(j.prop, {
                                options = {{action = function() OpenCraftMenu(v.CraftingTable,v.CraftEmote) end,icon = 'fas fa-hammer', label = "Crafting", targeticon = 'fas fa-hammer',item = v.ItemLocked,job = v.JobLocked,gang = v.GangLocked,citizenid = v.CIDLocked,},},
                                distance = 2.5,
                                })
                            end
                        end
                    end
                else
                    if v.Props then
                        for d,j in pairs(v.Props) do
                            TargetProp['CraftProp'..k..d] = 
                            exports['qb-target']:AddTargetModel(j.prop, {
                            options = {{action = function() OpenCraftMenu(v.CraftingTable,v.CraftEmote) end,icon = 'fas fa-hammer', label = "Crafting", targeticon = 'fas fa-hammer',item = v.ItemLocked,job = v.JobLocked,gang = v.GangLocked,citizenid = v.CIDLocked,},},
                            distance = 2.5,
                            })
                        end
                    end
                end
            end
        end
        for k,v in pairs(Config.CraftLocations) do
            if v.Enable then
                if v.LVLUnlocked then
                    if PlayerLVL >= v.LVLUnlocked then
                        if v.Locations then
                            for d,j in pairs(v.Locations) do
                                TargetLoc["CraftLocations"..k..d] =
    	                        exports['qb-target']:AddBoxZone("CraftLocations"..k..d, j.Coords, 2, 2, {name = "CraftLocations"..k..d,heading = j.Heading,debugPoly = false,minZ=j.Coords.z-2,maxZ=j.Coords.z+2,}, {
    	                        	options = {{action = function() OpenCraftMenu(v.CraftingTable,v.CraftEmote) end,icon = "fas fa-hammer",label = "Crafting",item = v.ItemLocked,job = v.JobLocked,gang = v.GangLocked,citizenid = v.CIDLocked,},},
    	                        	distance = 2.5,
    	                        })
                            end
                        end
                    end
                else
                    if v.Locations then
                        for d,j in pairs(v.Locations) do
                            TargetLoc["CraftLocations"..k..d] =
                            exports['qb-target']:AddBoxZone("CraftLocations"..k..d, j.Coords, 2, 2, {name = "CraftLocations"..k..d,heading = j.Heading,debugPoly = false,minZ=j.Coords.z-2,maxZ=j.Coords.z+2,}, {
                                options = {{action = function() OpenCraftMenu(v.CraftingTable,v.CraftEmote) end,icon = "fas fa-hammer",label = "Crafting",item = v.ItemLocked,job = v.JobLocked,gang = v.GangLocked,citizenid = v.CIDLocked,},},
                                distance = 2.5,
                            })
                        end
                    end
                end
            end
        end
        for k,v in pairs(Config.CraftPeds) do
            if v.Enable then
                if v.LVLUnlocked then
                    if PlayerLVL >= v.LVLUnlocked then
                        if v.Peds then
                            for d,j in pairs(v.Peds) do
                                TargetPed["CraftPed"..k..d] =
                                exports['qb-target']:SpawnPed({model = j.Model,coords = j.Coords, minusOne = Config.PedOptions['MinusOne'],freeze = Config.PedOptions['Freeze'],invincible = Config.PedOptions['Invincible'],blockevents = Config.PedOptions['IgnoreEvents'],
                                scenario = 'WORLD_HUMAN_DRUG_DEALER',
                                    target = {options = {{icon = "fas fa-hand",label = j.Label,action = function() OpenCraftMenu(v.CraftingTable,v.CraftEmote) end,item = v.ItemLocked,job = v.JobLocked,gang = v.GangLocked,citizenid = v.CIDLocked,},},
                                    distance = 2.5,
                                    },
                                })
                                if Config.DebugCode then print("SAYER-CRAFTING: ^4Ped ^7/ ^4LVL "..v.LVLUnlocked.." ^7/ ^4CraftPed "..k..d.." ^7Spawned") end
                                if j.SpeechRecognise then
                                    for p,m in pairs(j.SpeechRecognise) do
                                        if Config.DebugCode then print("Before Export") end
                                        exports["17mov_SpeechRecognition"]:NewAction({
                                            phrases = m.Phrase,
                                            allowRecognitionInReverse = m.AllowRecognitionInReverse,
                                            blockInVehicle = m.BlockInVehicle,
                                            actionType = "custom",
                                            actionFunction = function()
                                                if Config.DebugCode then print("ACTION RECOGNIZED") end
                                                if #(GetEntityCoords(PlayerPedId()) - vec3(j.Coords.x, j.Coords.y, j.Coords.z)) < 5.0 then
                                                    if PlayerLVL >= v.LVLUnlocked then
                                                        if Config.DebugCode then print("GetDistance = true") end
                                                        OpenCraftMenu(v.CraftingTable,v.CraftEmote)
                                                    else
                                                        QBCore.Functions.Notify('Leave Me Alone!', 'error')
                                                    end
                                                end
                                            end,
                                        })
                                        if Config.DebugCode then print("After Export") end
                                    end
                                end
                            end
                        end
                    end
                else
                    --if v.Peds then
                        for d2,j2 in pairs(v.Peds) do
                            TargetPed["CraftPed"..k..d2] =
                            exports['qb-target']:SpawnPed({model = j2.Model,coords = j2.Coords, minusOne = Config.PedOptions['MinusOne'],freeze = Config.PedOptions['Freeze'],invincible = Config.PedOptions['Invincible'],blockevents = Config.PedOptions['IgnoreEvents'],
                                scenario = 'WORLD_HUMAN_DRUG_DEALER',
                                target = {options = {{icon = "fas fa-hand",label = j2.Label,action = function() OpenCraftMenu(v.CraftingTable,v.CraftEmote) end,item = v.ItemLocked,job = v.JobLocked,gang = v.GangLocked,citizenid = v.CIDLocked,},},
                                distance = 2.5,
                                },
                            })
                            if Config.DebugCode then print("SAYER-CRAFTING: ^4Ped ^7/ ^4No LVL ^7/ ^4CraftPed "..k..d2.." ^7Spawned") end
                            if j2.SpeechRecognise then
                                for p2,m2 in pairs(j2.SpeechRecognise) do
                                    if Config.DebugCode then print("Before Export") end
                                    exports["17mov_SpeechRecognition"]:NewAction({
                                        phrases = m2.Phrase,
                                        allowRecognitionInReverse = m2.AllowRecognitionInReverse,
                                        blockInVehicle = m2.BlockInVehicle,
                                        actionType = "custom",
                                        actionFunction = function()
                                            if Config.DebugCode then print("ACTION RECOGNIZED") end
                                            if #(GetEntityCoords(PlayerPedId()) - vec3(j2.Coords.x, j2.Coords.y, j2.Coords.z)) < 5.0 then
                                                if Config.DebugCode then print("GetDistance = true") end
                                                OpenCraftMenu(v.CraftingTable,v.CraftEmote)
                                            end
                                        end,
                                    })
                                    if Config.DebugCode then print("After Export") end
                                end
                            end
                        end
                    --end
                end
            end
        end
        for k,v in pairs(Config.SpawnCraftProps) do
            if v.Enable then
                if v.LVLUnlocked then
                    if PlayerLVL >= v.LVLUnlocked then
                        for d,j in pairs(v.Locations) do
                            local model = ''
                            local entity = ''
                            model = v.prop
                            RequestModel(model)
                            while not HasModelLoaded(model) do
                              Wait(0)
                            end
                        
                            entity = CreateObject(model, j.Coords.x, j.Coords.y, j.Coords.z-1, v.Coords.w, false, true, false)
                            FreezeEntityPosition(entity,true)
                            PlaceObjectOnGroundProperly(entity)
                            SetEntityAsMissionEntity(entity)
                            SpawnTargetProp["SpawnTargetProp"..k..d] = 
                            exports['qb-target']:AddTargetEntity(entity,{
                                options = {{action = function() OpenCraftMenu(v.CraftingTable,v.CraftEmote) end,icon = "fas fa-hammer",label = "Crafting",item = v.ItemLocked,job = v.JobLocked,gang = v.GangLocked,citizenid = v.CIDLocked,},},
                                distance = 2.5,
                            })
                        end
                    end
                end
            end
        end
    end)
end

function GetDistance(PedCoord)
    print("Inside GetDistance")
    return #(GetEntityCoords(PlayerPedId()) - PedCoord) < 25.0
end

RegisterNetEvent('sayer-crafting:UseCraftItem', function(args)
    local table = args.CraftingTable
    local emote = args.CraftEmote
    if args.JobLocked then
        if QBCore.Functions.GetPlayerData().job.name == args.JobLocked then
            OpenCraftMenu(table,emote)
        else
            QBCore.Functions.Notify('You Need to be a '..QBCore.Shared.Jobs[args.JobLocked].label..' to use this', 'error')
        end
    end
    if args.GangLocked then
        if QBCore.Functions.GetPlayerData().gang.name == args.GangLocked then
            OpenCraftMenu(table,emote)
        else
            QBCore.Functions.Notify('You Need to be a '..QBCore.Shared.Gangs[args.GangLocked].label..' to use this', 'error')
        end
    end
    if args.ItemLocked then
        if QBCore.Functions.HasItem(args.ItemLocked) then
            OpenCraftMenu(table,emote)
        else
            QBCore.Functions.Notify('You Need a '..QBCore.Shared.Items[args.ItemLocked].label..' to use this', 'error')
        end
    end
    if args.CIDLocked then
        if QBCore.Functions.GetPlayerData().citizenid == args.CIDLocked then
            OpenCraftMenu(table,emote)
        else
            QBCore.Functions.Notify('You Cant Use This', 'error')
        end
    end
end)

RegisterNetEvent('sayer-crafting:ExternalBench',function(items,emote)
    if items ~= nil then
        OpenCraftMenu(items,emote)
    end
end)

RegisterNetEvent('sayer-crafting:ExternalRecycle', function()
    OpenRecycleMenu()
end)
             
function OpenCraftMenu(itemlist, Emote)
    local List = Config.CraftingTable[itemlist]
    local LVL = QBCore.Functions.GetPlayerData().metadata['sayercraftlevel']
    local XP = QBCore.Functions.GetPlayerData().metadata['sayercraftxp']
    local Needed = Config.Levels[LVL].NextLevel
    local Next = (Needed - XP)
    local columns = {
        {header = List.Label, isMenuHeader = true}, 
        {header = "Current Level = "..LVL.."! </br> Current XP = "..XP.."! </br> XP Needed For Level "..(LVL+1).." = "..Next.." !", isMenuHeader = true},
    }
    if Config.CustomMenu.HideLockedItems then
        for k, v in ipairs(List.Items) do
            if QBCore.Shared.Items[v.ItemCode] ~= nil then
                if LVL >= v.LVLNeeded then
                    local item = {}
                    item.header = "<img src=nui://"..Config.CustomMenu.InventoryLink..QBCore.Shared.Items[v.ItemCode].image.." width=35px style='margin-right: 10px'> " .. QBCore.Shared.Items[v.ItemCode].label
                    local text = ""
                    for d, j in ipairs(v.Recipe) do
                        if QBCore.Shared.Items[j.item] ~= nil then
                            text = text .. "- " .. QBCore.Shared.Items[j.item].label .. ": " .. j.amount .. "<br>"
                        else
                            print('^1SAYER-CRAFTING: ^7Cannot Find ^4'..j.item..' ^7From ^4Recipes ^7In ^4Shared/Items.lua')
                        end
                    end
                    item.text = text
                    item.params = {event = 'sayer-crafting:MakeItem',args = {type = v.ItemCode, list = List.Items, amount = v.Amount,emote = Emote,xp = v.XPGain,index = k}}
                    table.insert(columns, item)
                end
            else
                print('^1SAYER-CRAFTING: ^7Cannot Find ^4'..v.ItemCode..' ^7From ^4CraftingTable ^7In ^4Shared/Items.lua')
            end
        end
    else
        for k, v in ipairs(List.Items) do
            if QBCore.Shared.Items[v.ItemCode] ~= nil then
                local item = {}
                if Config.CustomMenu.ShowLevelRequired then
                    item.header = "<img src=nui://"..Config.CustomMenu.InventoryLink..QBCore.Shared.Items[v.ItemCode].image.." width=35px style='margin-right: 10px'> " .. QBCore.Shared.Items[v.ItemCode].label.."! |Level Required = "..v.LVLNeeded
                else
                    item.header = "<img src=nui://"..Config.CustomMenu.InventoryLink..QBCore.Shared.Items[v.ItemCode].image.." width=35px style='margin-right: 10px'> " .. QBCore.Shared.Items[v.ItemCode].label
                end
                local text = ""
                for d, j in ipairs(v.Recipe) do
                    if QBCore.Shared.Items[j.item] ~= nil then
                        text = text .. "- " .. QBCore.Shared.Items[j.item].label .. ": " .. j.amount .. "<br>"
                    else
                        print('^1SAYER-CRAFTING: ^7Cannot Find ^4'..j.item..' ^7From ^4Recipes ^7In ^4Shared/Items.lua')
                    end
                end
                item.text = text
                if LVL >= v.LVLNeeded then
                    item.params = {event = 'sayer-crafting:MakeItem',args = {type = v.ItemCode, list = List.Items, amount = v.Amount,emote = Emote,xp = v.XPGain,index = k}}
                else
                    item.params = {event = 'sayer-crafting:NeedHigherLevel',args = {needed = v.LVLNeeded,level = LVL}}
                end
                table.insert(columns, item)
            else
                print('^1SAYER-CRAFTING: ^7Cannot Find ^4'..v.ItemCode..' ^7From ^4CraftingTable ^7In ^4Shared/Items.lua')
            end
        end
    end

    exports['qb-menu']:openMenu(columns)
end

RegisterNetEvent('sayer-crafting:NeedHigherLevel', function(data)
    LVL = data.level
    Needed = data.needed
    QBCore.Functions.Notify("You Need to be Level "..Needed.." To craft this!",'error')
end)

RegisterNetEvent('sayer-crafting:MakeItem', function(data)
    QBCore.Functions.TriggerCallback("sayer-crafting:itemchecker", function(check)
        if (check) and not IsBusy then
            MakeCraftingItem(data.type, data.list, data.amount,data.emote,data.xp,data.index)
        else
            QBCore.Functions.Notify('You Dont Have The Items For This!', 'error')
            return
        end
    end, data.list[data.index].Recipe)
end)

function MakeCraftingItem(item,list,receive,emote,xp,index)
    if not IsBusy then
        IsBusy = true

        TriggerEvent('animations:client:EmoteCommandStart', {emote})
        QBCore.Functions.Progressbar('cooking_food', "Making "..QBCore.Shared.Items[item].label, list[index].CraftTime * 1000, false, false, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,},
        {}, {}, {}, function()

        local success = list[index].SuccessChance
        local random = math.random(1,100)

        if random <= success then
            TriggerServerEvent('sayer-crafting:MakeFinal', item, receive)
            if xp then
                TriggerServerEvent('sayer-crafting:AddXP',xp)
            end
        else
            QBCore.Functions.Notify('You Failed Crafting', 'error')
        end

        for k, v in pairs(list[index].Recipe) do
            TriggerServerEvent('sayer-crafting:RemoveItem', v.item, v.amount)
        end

        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        IsBusy = false
        end, function() -- Cancel

        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify('Cancelled...', 'error')
        IsBusy = false
        end)
    else
        QBCore.Functions.Notify('You Are Busy...', 'error')
    end
end

function OpenRecycleMenu()
    local List = Config.Recycle
    local columns = {
        {header = "Recycling", isMenuHeader = true}, 
    }
    for k, v in pairs(List) do
        if QBCore.Shared.Items[k] ~= nil then
            if QBCore.Functions.HasItem(k) then
                local item = {}
                item.header = "<img src=nui://"..Config.CustomMenu.InventoryLink..QBCore.Shared.Items[k].image.." width=35px style='margin-right: 10px'> " .. QBCore.Shared.Items[k].label
                local text = ""
                for d, j in ipairs(List[k]) do
                    if QBCore.Shared.Items[j.item] ~= nil then
                        text = text .. "- " .. QBCore.Shared.Items[j.item].label .. " <br>"
                    else
                        print('^1SAYER-CRAFTING: ^7Cannot Find ^4'..j.item..' ^7From ^4Recycling ^7In ^4Shared/Items.lua')
                    end
                end
                item.text = text
                item.params = {event = 'sayer-crafting:RecycleItem',args = {type = k}}
                table.insert(columns, item)
            end
        else
            print('^1SAYER-CRAFTING: ^7Cannot Find ^4'..k..' ^7From ^4Recycling ^7In ^4Shared/Items.lua')
        end
    end

    exports['qb-menu']:openMenu(columns)
end

RegisterNetEvent('sayer-crafting:RecycleItem', function(data)
    if QBCore.Functions.HasItem(data.type) then
        RecycleItem(data.type)
    else
        QBCore.Functions.Notify('You Dont Have The Items For This!', 'error')
        return
    end
end)

function RecycleItem(item)
    if not IsBusy then
        IsBusy = true

        TriggerEvent('animations:client:EmoteCommandStart', {'mechanic'})
        QBCore.Functions.Progressbar('cooking_food', "Recycling "..QBCore.Shared.Items[item].label, Config.RecycleTime * 1000, false, false, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,},
        {}, {}, {}, function()

        local success = Config.RecycleSuccessChance
        local random = math.random(1,100)

        if random <= success then
            TriggerServerEvent('sayer-crafting:RemoveItem', item, 1)
            QBCore.Functions.Notify("Successfully Recycled"..QBCore.Shared.Items[item].label.."!", 'success')
            for k, v in pairs(Config.Recycle[item]) do
                TriggerServerEvent('sayer-crafting:MakeFinal', v.item, math.random(v.Min,v.Max))
            end
        else
            TriggerServerEvent('sayer-crafting:RemoveItem', item, 1)
            QBCore.Functions.Notify('The Materials Got Messed Up!', 'error')
        end

        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        IsBusy = false
        Wait(1000)
        OpenRecycleMenu()
        end, function() -- Cancel

        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify('Cancelled...', 'error')
        IsBusy = false
        end)
    else
        QBCore.Functions.Notify('You Are Busy...', 'error')
    end
end

AddEventHandler('onResourceStop', function(t) if t ~= GetCurrentResourceName() then return end
	for k in pairs(TargetProp) do exports['qb-target']:RemoveTargetModel(k) end
    for k in pairs(SpawnTargetProp) do exports['qb-target']:RemoveTargetModel(k) end
    for k in pairs(TargetPed) do exports['qb-target']:RemoveSpawnedPed(k) end
    for k in pairs(TargetLoc) do exports['qb-target']:RemoveZone(k) end
end)