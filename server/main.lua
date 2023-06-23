local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('sayer-crafting:itemchecker', function(source, cb, Recipe)
    local src = source
    local hasItems = false
    local itemcount = 0
    local player = QBCore.Functions.GetPlayer(source)
    for k, v in pairs(Recipe) do
        if player.Functions.GetItemByName(v.item) and player.Functions.GetItemByName(v.item).amount >= v.amount then
            itemcount = itemcount + 1
            if itemcount == #Recipe then
                cb(true)
            end
        else
            cb(false)
            return
        end
    end
end)

for k, v in pairs(Config.CraftItems) do
	QBCore.Functions.CreateUseableItem(k, function(source, item)
        TriggerClientEvent('sayer-crafting:UseCraftItem', source, v)
    end)
end 

RegisterNetEvent('sayer-crafting:MakeFinal', function(item, receive)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Name = Player.PlayerData.name
    local ID = Player.PlayerData.cid
    Player.Functions.AddItem(item, receive)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add")
    SendDiscordMessage("Created Item!","Player = "..Name.." </br> ID = ( "..ID.." ) </br> Crafted x"..receive.." of Item = "..QBCore.Shared.Items[item].label.."!")
end)

RegisterNetEvent('sayer-crafting:RemoveItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
end)

RegisterNetEvent('sayer-crafting:SetLevel', function(level)
    local Player = QBCore.Functions.GetPlayer(source)
    local CurLevel = Player.PlayerData.metadata['sayercraftlevel']
    Player.Functions.SetMetaData('sayercraftlevel', level)
end)

RegisterNetEvent('sayer-crafting:SetXP', function(xp)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.SetMetaData('sayercraftxp', xp)
end)

RegisterNetEvent('sayer-crafting:AddXP', function(xp)
    local Player = QBCore.Functions.GetPlayer(source)
    local EXP = Player.PlayerData.metadata['sayercraftxp']
    local level = Player.PlayerData.metadata['sayercraftlevel']
    local Name = Player.PlayerData.name
    local ID = Player.PlayerData.cid

    if level <= #Config.Levels then
        if (EXP+xp) >= Config.Levels[level].NextLevel then
            Player.Functions.SetMetaData('sayercraftlevel', (level+1))
            Player.Functions.SetMetaData('sayercraftxp', 0)
            TriggerClientEvent('QBCore:Notify', src, "Your Crafting Level Has Increased", 'success')
            SendDiscordMessage("Level Up!","Player = "..Name..".</br> ID = ( "..ID.." ) </br> Reached Level ( "..(level+1).." ) ")
        else
            Player.Functions.SetMetaData('sayercraftxp', (EXP+xp))
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Your Crafting Level Cant Increase More!", 'error')
    end
end)

--WEBHOOK STUFF

local webhookUrl = Config.Webhooks.URL 
function SendDiscordMessage(title,message)
    if Config.Webhooks.Enable then
        local embedData = {
            {
                ['title'] = title or "Sayer Crafting",
                ['color'] = 16744192,
                ['footer'] = {
                    ['text'] = os.date('%c'),
                },
                ['description'] = message,
                ['author'] = {
                    ['name'] = 'Sayer Crafting',
                    ['icon_url'] = 'https://cdn.discordapp.com/attachments/1061012675112476672/1061012749133565962/oosayerooscriptspng.png',
                },
            }
        }
        PerformHttpRequest(webhookUrl, function() end, 'POST', json.encode({ username = 'Sayer Shops', embeds = embedData}), { ['Content-Type'] = 'application/json' })
    end
end