local QBCore = exports['qb-core']:GetCoreObject()

local SpawnTargetProp = {}
local SpawnModelProp = {}
local TargetProp = {}
local ModelProp = {}
local TargetLoc = {}
local IsBusy = false
MyLevels = {}

AddEventHandler('onResourceStart', function(resource) 
    if GetCurrentResourceName() ~= resource then return end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    
end)

CreateThread(function()
    for k,v in pairs(Config.CraftProps) do
        if v.Enable then
            if v.Props then
                for d,j in pairs(v.Props) do
                    TargetProp['CraftProp'..k..d] = 
                    AddGlobalModel(j.prop, {
                        {
                            action = function()
                                OpenCraftMenu(v.CraftingTable,v.CraftEmote,v.LevelData)
                            end,
                            icon = "fas fa-hammer",
                            label = "Crafting",
                            job = v.JobLocked,
                            item = v.ItemLocked,
                            gang = v.GangLocked,
                            citizenid = v.CIDLocked,
                            distance = 2.0,
                        },
                    }, 2.5)
                end
            end
        end
    end
    for k,v in pairs(Config.CraftLocations) do
        if v.Enable then
            if v.Locations then
                for d,j in pairs(v.Locations) do
                    TargetLoc["CraftLocations"..k..d] =
                        SetupBoxZone(
                        "CraftLocations"..k..d, --name
                        j.Coords, --vector3
                        {x = 2, y = 2}, --size
                        { --options
                            {
                                action = function()
                                    OpenCraftMenu(v.CraftingTable,v.CraftEmote,v.LevelData)
                                end,
                                icon = "fas fa-hammer",
                                label = "Crafting",
                                job = v.JobLocked,
                                item = v.ItemLocked,
                                gang = v.GangLocked,
                                citizenid = v.CIDLocked
                            },
                        },
                        2.5, --distance
                        false, --debug poly
                        j.Coords.z-2, --minZ
                        j.Coords.z+2  --maxZ
                    )
                end
            end
        end
    end
    for k,v in pairs(Config.SpawnCraftProps) do
        if v.Enable then
            for d,j in pairs(v.Locations) do
                local model = ''
                local entity = ''
                model = v.prop
                RequestModel(model)
                while not HasModelLoaded(model) do
                  Wait(0)
                end
            
                SpawnModelProp["SpawnedCraftModel"..k..d] = CreateObject(model, j.Coords.x, j.Coords.y, j.Coords.z-1, false, true, false)
		        SetEntityHeading(SpawnModelProp["SpawnedCraftModel"..k..d],j.Coords.w)
                FreezeEntityPosition(SpawnModelProp["SpawnedCraftModel"..k..d],true)
                PlaceObjectOnGroundProperly(SpawnModelProp["SpawnedCraftModel"..k..d])
                SetEntityAsMissionEntity(SpawnModelProp["SpawnedCraftModel"..k..d])
                SpawnTargetProp["SpawnTargetProp"..k..d] = 
                SetupTargetEntity(SpawnModelProp["SpawnedCraftModel"..k..d], {
                    {
                        action = function()
                            OpenCraftMenu(v.CraftingTable,v.CraftEmote,v.LevelData)
                        end,
                        icon = "fas fa-hammer",
                        label = "Crafting",
                        job = v.JobLocked,
                        item = v.ItemLocked,
                        gang = v.GangLocked,
                        citizenid = v.CIDLocked,
                        distance = 2.0
                    },
                }, 2.5)
            end
        end
    end
end)

RegisterNetEvent('sayer-crafting:UseCraftItem', function(args)
    local table = args.CraftingTable
    local emote = args.CraftEmote
    if args.JobLocked then
        if QBCore.Functions.GetPlayerData().job.name == args.JobLocked then
            OpenCraftMenu(table,emote)
        else
            SendNotify('You Need to be a '..QBCore.Shared.Jobs[args.JobLocked].label..' to use this', 'error')
        end
    end
    if args.GangLocked then
        if QBCore.Functions.GetPlayerData().gang.name == args.GangLocked then
            OpenCraftMenu(table,emote)
        else
            SendNotify('You Need to be a '..QBCore.Shared.Gangs[args.GangLocked].label..' to use this', 'error')
        end
    end
    if args.ItemLocked then
        if QBCore.Functions.HasItem(args.ItemLocked) then
            OpenCraftMenu(table,emote)
        else
            SendNotify('You Need a '..QBCore.Shared.Items[args.ItemLocked].label..' to use this', 'error')
        end
    end
    if args.CIDLocked then
        if QBCore.Functions.GetPlayerData().citizenid == args.CIDLocked then
            OpenCraftMenu(table,emote)
        else
            SendNotify('You Cant Use This', 'error')
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

function TriggerCraftingUI(itemlist, Emote, LevelData)
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open-sayer-crafting",
        Items = itemlist,
        Emote = Emote,
        LevelData = LevelData
    })
end

function OpenCraftMenu(itemlist, Emote, LevelData)
    local List = Config.CraftingTable[itemlist]
    local LVLData = lib.callback.await('sayer-crafting:getLevelData', false, LevelData)
    if LVLData then
        if Config.Menu == 'UI' then TriggerCraftingUI(List, Emote, LVLData) return end
        local Needed = Config.Levels[LVLData.level].NextLevel
        local Next = (Needed - LVLData.xp)
        local columns = {
            {header = List.Label, isMenuHeader = true}, 
            {header = "Current Level = "..LVLData.level.."! <br> Current XP = "..LVLData.xp.."! <br> XP Needed For Level "..(LVLData.level+1).." = "..Next.." !", isMenuHeader = true},
        }
        for k, v in ipairs(List.Items) do
            if DoesItemExist(v.ItemCode) then
                local itemDetails = GetItemDetails(v.ItemCode)
                local item = {}
                if Config.CustomMenu.ShowLevelRequired then
                    item.header = itemDetails.label.."! |Level Required = "..v.LVLNeeded
                else
                    item.header = itemDetails.label
                end
                local text = ""
                for d, j in ipairs(v.Recipe) do
                    if DoesItemExist(j.item) then
                        local ingredientDetails = GetItemDetails(j.item)
                        text = text .. "- " .. ingredientDetails.label .. ": " .. j.amount .. "<br>"
                    else
                        print('^1SAYER-CRAFTING: ^7Cannot Find ^4'..j.item..' ^7From ^4Recipes ^7In ^4Shared/Items.lua')
                    end
                end
                item.text = text
                if LVLData.level >= v.LVLNeeded then
                    item.params = {event = 'sayer-crafting:MakeItem',args = {type = v.ItemCode, list = List.Items, amount = v.Amount,emote = Emote,xp = v.XPGain,index = k, LevelData = LevelData}}
                else
                    item.params = {event = 'sayer-crafting:NeedHigherLevel',args = {needed = v.LVLNeeded,level = LVLData.level}}
                end
                table.insert(columns, item)
            else
                print('^1SAYER-CRAFTING: ^7Cannot Find ^4'..v.ItemCode..' ^7From ^4CraftingTable ^7In ^4Shared/Items.lua')
            end
        end
        TriggerMenu("CraftingMenu","Crafting",columns)
    else
        DebugCode("Level Data is NIL")
    end
end

RegisterNetEvent('sayer-crafting:NeedHigherLevel', function(data)
    LVL = data.level
    Needed = data.needed
    SendNotify("You Need to be Level "..Needed.." To craft this!",'error')
end)

RegisterNetEvent('sayer-crafting:MakeItem', function(data)
    local HasItems = lib.callback.await('sayer-crafting:itemchecker', data.list[data.index].Recipe)
    if HasItems and not IsBusy then
        MakeCraftingItem(data.type, data.list, data.amount,data.emote,data.xp,data.index,data.LevelData)
    else
        SendNotify('You Dont Have The Items For This!', 'error')
        return
    end
end)

function MakeCraftingItem(item,list,receive,emote,xp,index,LevelData)
    if not IsBusy then
        IsBusy = true
        local itemDetails = GetItemDetails(item)
        local crafttime = list[index].CraftTime * 1000

        TriggerEmote(emote)
        DoProgressBar("Making "..itemDetails.label, crafttime, function(finished)
            if finished then
                local success = list[index].SuccessChance
                local random = math.random(1,100)

                if random <= success then
                    TriggerServerEvent('sayer-crafting:CreateFinalStage', item, receive, list[index].Recipe,LevelData,xp)
                else
                    SendNotify('You Failed Crafting', 'error')
                end

                CancelEmote()
                ClearPedTasks(PlayerPedId())
                IsBusy = false
            else
                CancelEmote()
                ClearPedTasks(PlayerPedId())
                SendNotify('Cancelled...', 'error')
                IsBusy = false
            end

        end)
    else
        SendNotify('You Are Busy...', 'error')
    end
end

-- function OpenRecycleMenu()
--     local List = Config.Recycle
--     local columns = {
--         {header = "Recycling", isMenuHeader = true}, 
--     }
--     for k, v in pairs(List) do
--         if QBCore.Shared.Items[k] ~= nil then
--             if QBCore.Functions.HasItem(k) then
--                 local item = {}
--                 item.header = "<img src=nui://"..Config.CustomMenu.InventoryLink..QBCore.Shared.Items[k].image.." width=35px style='margin-right: 10px'> " .. QBCore.Shared.Items[k].label
--                 local text = ""
--                 for d, j in ipairs(List[k]) do
--                     if QBCore.Shared.Items[j.item] ~= nil then
--                         text = text .. "- " .. QBCore.Shared.Items[j.item].label .. " <br>"
--                     else
--                         print('^1SAYER-CRAFTING: ^7Cannot Find ^4'..j.item..' ^7From ^4Recycling ^7In ^4Shared/Items.lua')
--                     end
--                 end
--                 item.text = text
--                 item.params = {event = 'sayer-crafting:RecycleItem',args = {type = k}}
--                 table.insert(columns, item)
--             end
--         else
--             print('^1SAYER-CRAFTING: ^7Cannot Find ^4'..k..' ^7From ^4Recycling ^7In ^4Shared/Items.lua')
--         end
--     end

--     exports['qb-menu']:openMenu(columns)
-- end

-- RegisterNetEvent('sayer-crafting:RecycleItem', function(data)
--     if QBCore.Functions.HasItem(data.type) then
--         RecycleItem(data.type)
--     else
--         SendNotify('You Dont Have The Items For This!', 'error')
--         return
--     end
-- end)

-- function RecycleItem(item)
--     if not IsBusy then
--         IsBusy = true

--         TriggerEvent('animations:client:EmoteCommandStart', {'mechanic'})
--         QBCore.Functions.Progressbar('cooking_food', "Recycling "..QBCore.Shared.Items[item].label, Config.RecycleTime * 1000, false, false, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,},
--         {}, {}, {}, function()

--         local success = Config.RecycleSuccessChance
--         local random = math.random(1,100)

--         if random <= success then
--             TriggerServerEvent('sayer-crafting:RemoveItem', item, 1)
--             SendNotify("Successfully Recycled"..QBCore.Shared.Items[item].label.."!", 'success')
--             for k, v in pairs(Config.Recycle[item]) do
--                 TriggerServerEvent('sayer-crafting:MakeFinal', v.item, math.random(v.Min,v.Max))
--             end
--         else
--             TriggerServerEvent('sayer-crafting:RemoveItem', item, 1)
--             SendNotify('The Materials Got Messed Up!', 'error')
--         end

--         TriggerEvent('animations:client:EmoteCommandStart', {"c"})
--         ClearPedTasks(PlayerPedId())
--         IsBusy = false
--         Wait(1000)
--         OpenRecycleMenu()
--         end, function() -- Cancel

--         ClearPedTasks(PlayerPedId())
--         SendNotify('Cancelled...', 'error')
--         IsBusy = false
--         end)
--     else
--         SendNotify('You Are Busy...', 'error')
--     end
-- end

AddEventHandler('onResourceStop', function(t) if t ~= GetCurrentResourceName() then return end
    for _,v in pairs(TargetLoc) do RemoveBoxZone(v) end
    for _,v in pairs(TargetProp) do RemoveTargetModel(v) end
    for _,v in pairs(SpawnTargetProp) do RemoveTargetEntity(v) end
    for _,v in pairs(SpawnModelProp) do 
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
end)
