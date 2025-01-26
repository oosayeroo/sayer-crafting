local QBCore = exports['qb-core']:GetCoreObject()

lib.callback.register('sayer-crafting:itemchecker', function(source, cb, Recipe)
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

lib.callback.register('sayer-crafting:getLevels', function(source)
    local src = source
    local myLevels = {}
    local player = QBCore.Functions.GetPlayer(source)
    local citizenid = player.PlayerData.citizenid

    MySQL.rawExecute('SELECT * FROM sayer_crafting WHERE citizenid = ?', { citizenid }, function(result)
        if result[1] then
            tempTable = json.decode(result[1].levels)
            for k,v in pairs(tempTable) do
                myLevels[k] = {level = v.level,xp = v.xp}
            end
            return myLevels
        else
            return nil
        end    
    end)
end)

lib.callback.register('sayer-crafting:getSpecificLevel', function(source, level)
    local src = source
    local myLevel = 0
    local player = QBCore.Functions.GetPlayer(source)
    local citizenid = player.PlayerData.citizenid

    MySQL.rawExecute('SELECT * FROM sayer_crafting WHERE citizenid = ?', { citizenid }, function(result)
        if result[1] then
            tempTable = json.decode(result[1].levels)
            if tempTable[level] ~= nil then
                myLevel = tempTable[level].level
                return myLevel
            else
                return 0
            end
        else
            return 0
        end    
    end)
end)

lib.callback.register('sayer-crafting:getLevelData', function(source, level)
    local src = source
    local myLevel = {level = 0,xp = 0}
    local player = QBCore.Functions.GetPlayer(source)
    local citizenid = player.PlayerData.citizenid
    DebugCode(level)

    MySQL.rawExecute('SELECT * FROM sayer_crafting WHERE citizenid = ?', { citizenid }, function(result)
        if result[1] then
            tempTable = json.decode(result[1].levels)
            if tempTable[level] ~= nil then
                myLevel = {level = tempTable[level].level, xp = tempTable[level].xp}
                DebugCode("TABLE EXISTS : MY LEVEL: "..myLevel.level.." : MY XP: "..myLevel.xp)
            else
                DebugCode("NO TABLE EXISTS : MY LEVEL: "..myLevel.level.." : MY XP: "..myLevel.xp)
            end
        else
            DebugCode("NO PLAYER INFO EXISTS: MY LEVEL: "..myLevel.level.." : MY XP: "..myLevel.xp)
        end    
    end)
    return myLevel
end)

for k, v in pairs(Config.CraftItems) do
	QBCore.Functions.CreateUseableItem(k, function(source, item)
        TriggerClientEvent('sayer-crafting:UseCraftItem', source, v)
    end)
end 

RegisterNetEvent('sayer-crafting:CreateFinalStage', function(item, receive, recipe, LevelData,xp)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Name = Player.PlayerData.name
    local ID = Player.PlayerData.cid
    local hasFailed = false
    for k,v in pairs(recipe) do
        if not removeItem(src, v.item, v.amount) then
            hasFailed = true
        end
    end

    if not hasFailed then
        addItem(src, item, receive)
        addXP(src,LevelData,xp)
        SendDiscordMessage("Created Item!","Player = "..Name.." </br> ID = ( "..ID.." ) </br> Crafted x"..receive.." of Item = "..QBCore.Shared.Items[item].label.."!")
    else
        TriggerClientEvent('QBCore:Notify', src, "You No Longer Have The Items", 'error')
    end
end)

RegisterNetEvent('sayer-crafting:RemoveItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
end)

function addXP(src,LevelData,xp)
    if not xp then return end
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    local tempTable = {}
    local nextXP = 0
    local myLevelData = {}

    MySQL.rawExecute('SELECT * FROM sayer_crafting WHERE citizenid = ?', { citizenid }, function(result)
        if result[1] then
            tempTable = json.decode(result[1].levels)
            if tempTable[LevelData] ~= nil then
                myLevelData = {level = tempTable[level].level, xp = tempTable[level].xp}
                local newXP = myLevelData.xp + xp
                local maxXP = Config.Levels[myLevelData.level].NextLevel
                if newXP > maxXP then
                    newXP = 0
                    local newLevel = myLevelData.level + 1
                    if Config.Levels[newLevel] ~= nil then
                        tempTable[LevelData] = {level = newLevel,xp = 0}
                        local finaltempTable = json.encode(tempTable)
                        MySQL.update('UPDATE sayer_crafting SET levels = ? WHERE citizenid = ?', { finaltempTable, citizenid })
                    end
                else
                    tempTable[LevelData].xp = newXP
                    local finaltempTable = json.encode(tempTable)
                    MySQL.update('UPDATE sayer_crafting SET levels = ? WHERE citizenid = ?', { finaltempTable, citizenid })
                end
            else
                tempTable[LevelData] = {level = 1,xp = xp}
                finaltempTable = json.encode(tempTable)
                MySQL.update('UPDATE sayer_crafting SET levels = ? WHERE citizenid = ?', { finaltempTable, citizenid })
            end
        else
            local defaultTable = {}
            defaultTable[LevelData] = {level = 1,xp = xp}
            local finaltempTable = json.encode(defaultTable)
            MySQL.insert('INSERT INTO sayer_crafting (citizenid, levels) VALUES (?, ?)', {
                citizenid,
                finaltempTable,
            })
        end     
    end)
end

function addItem(src, item, amount)
    amount = amount or 1
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        DebugCode("Error: Player not found for source:", src)
        return false
    end

    if Config.Inventory == 'qb' then
        if Player.Functions.AddItem(item, amount) then
            return true
        else
            DebugCode("Error: Failed to add item to QB inventory:", item, "Amount:", amount)
            return false
        end
    elseif Config.Inventory == 'ox' then
        local success, response = exports.ox_inventory:AddItem(src, item, amount)
        if success then
            return true
        else
            DebugCode("Error: Failed to add item to OX inventory:", item, "Amount:", amount, "Response:", response)
            return false
        end
    else
        DebugCode("Error: Unsupported inventory type in Config.Inventory")
        return false
    end
end

function removeItem(src, item, amount)
    amount = amount or 1
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        DebugCode("Error: Player not found for source:", src)
        return false
    end

    if Config.Inventory == 'qb' then
        if Player.Functions.RemoveItem(item, amount) then
            return true
        else
            DebugCode("Error: Failed to remove item to QB inventory:", item, "Amount:", amount)
            return false
        end
    elseif Config.Inventory == 'ox' then
        local success = exports.ox_inventory:RemoveItem(src, item, amount)
        if success then
            return true
        else
            DebugCode("Error: Failed to remove item to OX inventory:", item, "Amount:", amount)
            return false
        end
    else
        DebugCode("Error: Unsupported inventory type in Config.Inventory")
        return false
    end
end

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

function DebugCode(msg)
    if Config.DebugCode then
        print(msg)
    end
end