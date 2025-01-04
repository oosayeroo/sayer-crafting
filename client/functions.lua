local QBCore = exports['qb-core']:GetCoreObject()

-- INVENTORY

function DoesItemExist(item)
    local retval = false
    if Config.Inventory == 'qb' then
        if QBCore.Shared.Items[item] ~= nil then
            retval = true
        else
            retval = false
        end
    elseif Config.Inventory == 'ox' then
        local isItem = exports.ox_inventory:Items(item)
        if isItem ~= nil then
            retval = true
        else
            retval = false
        end
    end
    return retval
end

function GetItemDetails(item)
    local retval = nil
    local link = {}
    if Config.Inventory == 'qb' then
        retval = QBCore.Shared.Items[item]
    elseif Config.Inventory == 'ox' then
        local temp = exports.ox_inventory:Items(item)
        link = temp
        if temp.client then
            if temp.client.image then
                link.image = temp.client.image
            else
                link.image = item..'.png'
            end
        else
            link.image = item..'.png'
        end
        retval = link
    end
    return retval
end

--DEBUG

function DebugCode(msg)
    if Config.DebugCode then
        print(msg)
    end
end

-- PROGRESSBAR

function DoProgressBar(Label,Time)
    local retval = false
    if Config.Progressbar == 'qb' then
        QBCore.Functions.Progressbar('sayer_jobdelivery', Label, Time, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            retval = true
        end, function() -- Cancel
            retval = false
        end)
    elseif Config.Progressbar == 'ox' then
        if lib.progressCircle({    duration = Time,    position = 'bottom',    useWhileDead = false,    canCancel = true,    disable = {        car = true,    },}) then 
            retval = true 
        else 
            retval = false
        end
    end
    return retval
end

-- EMOTES

function TriggerEmote(emote)
    if not emote then return end
    ExecuteCommand("e "..emote)
end

function CancelEmote()
    ExecuteCommand("e c")
end

-- NOTIFY

function SendNotify(MSG,TYPE,TITLE,TIME)
    if not TYPE then TYPE = 'success' end
    if not TITLE then TITLE = "Trapping" end
    if not TIME then TIME = 5000 end
    if Config.Notify == 'qb' then
        QBCore.Functions.Notify(MSG,TYPE,TIME)
    elseif Config.Notify == 'okok' then
        exports['okokNotify']:Alert(TITLE, MSG, TIME, TYPE, false)
    elseif Config.Notify == 'qs' then
        exports['qs-notify']:Alert(MSG, TIME, TYPE)
    elseif Config.Notify == 'ox' then
        lib.notify({
            title = TITLE,
            description = MSG,
            type = TYPE
        })
    elseif Config.Notify == 'mythic' then
        exports['mythic_notify']:DoHudText(TYPE, MSG)
    elseif Config.Notify == 'boii' then
        exports['boii_ui']:notify(TITLE, MSG, TYPE, TIME)
    end
end

-- TARGET

function ConvertOptions(options)
    local convertedOptions = {}

    if Config.Target == 'qb' then
        return options
    elseif Config.Target == 'ox' then
        for _, option in ipairs(options) do
            table.insert(convertedOptions, {
                icon = option.icon,
                label = option.label,
                job = option.job or false,
                gang = option.gang or false,
                onSelect = option.action
            })
        end
        return convertedOptions
    end
end

function SetupBoxZone(name, coords, size, options, distance, debugPoly, minZ, maxZ)
    local adjustedOptions = ConvertOptions(options)

    if Config.Target == 'qb' then
        return exports['qb-target']:AddBoxZone(name, coords, size.x, size.y, {
            name = name,
            heading = 0,
            debugPoly = debugPoly,
            minZ = minZ,
            maxZ = maxZ,
        }, {
            options = adjustedOptions,
            distance = distance
        })
    elseif Config.Target == 'ox' then
        return exports.ox_target:addBoxZone({
            coords = coords,
            size = vector3(size.x, size.y, (maxZ - minZ)),
            rotation = 0, 
            debug = debugPoly,
            options = adjustedOptions
        })
    end
end

function SetupTargetEntity(entity, options, distance)
    local adjustedOptions = ConvertOptions(options) -- Convert options based on the target system

    if Config.Target == 'qb' then
        return exports['qb-target']:AddTargetEntity(entity, {
            options = adjustedOptions,
            distance = distance
        })
    elseif Config.Target == 'ox' then
        return exports['ox_target']:addLocalEntity(entity, adjustedOptions)
    end
end

function AddGlobalModel(model, options, distance)
    local adjustedOptions = ConvertOptions(options)

    if Config.Target == 'qb' then
        return exports['qb-target']:AddTargetModel(model, {
            options = adjustedOptions,
            distance = distance
        })
    elseif Config.Target == 'ox' then
        return exports['ox_target']:addModel(model,adjustedOptions)
    end
end

function RemoveBoxZone(name)
    if Config.Target == 'qb' then
        exports['qb-target']:RemoveZone(name)
    elseif Config.Target == 'ox' then
        exports['ox_target']:removeZone(name)
    end
end

function RemoveTargetEntity(name)
    if Config.Target == 'qb' then
        exports['qb-target']:RemoveTargetEntity(name)
    elseif Config.Target == 'ox' then
        exports.ox_target:removeLocalEntity(name)
    end
end

function RemoveTargetModel(name)
    if Config.Target == 'qb' then
        exports['qb-target']:RemoveTargetModel(name)
    elseif Config.Target == 'ox' then
        exports.ox_target:removeModel(name)
    end
end

-- MENU

function TriggerMenu(ID,TITLE,data)
    if not data then return end
    if Config.Menu == 'qb' then
        exports['qb-menu']:openMenu(data)
    elseif Config.Menu == 'ox' then
        local convertedData = ConvertQBMenuToOXMenu(data)
        lib.registerContext({
            id = ID,
            title = TITLE,
            options = convertedData,
        })
        lib.showContext(ID)
    end
end

function ConvertQBMenuToOXMenu(data)
    local newData = {}
    for k, v in pairs(data) do
        local option = {}
        if v.header then
            option.title = v.header:gsub("<br>", "\n")
        end
        if v.text then
            option.description = v.text:gsub("<br>", "\n")
        end
        if v.params then
            if v.params.event then
                option.event = v.params.event
            end
            if v.params.args then
                option.args = v.params.args
            end
        end
        if option ~= nil then
            table.insert(newData, option)
        end
    end
    return newData
end