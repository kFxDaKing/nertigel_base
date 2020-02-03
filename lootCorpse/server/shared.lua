ESX = nil

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(100)
        end
    end)


local locked = {}


function isLocked(id)
    return locked[id]
end

function setLock(id, owner)
    locked[id] = owner
end


function hasLootPermission(id)
    local player = ESX.GetPlayerFromId(id)

    if #Config.AllowedGroups > 0 then
        if not Config.AllowedGroups[player.getGroup()] then
            return false
        end
    end

    if #Config.AllowedJobs > 0 then
        if not Config.AllowedJobs[player.getJob()] then
            return false
        end
    end

    return true
end


function canLoot(id)
    if isLocked(id) then
        return false
    end

    local player = ESX.GetPlayerFromId(id)

    for _, item in pairs(player.getInventory()) do
        if item.count > 0 and item.canRemove then
            return true
        end
    end

    if #player.getLoadout() > 0 then
        return true
    end

    if player.getMoney() > 0 then
        return true
    end

    for _, account in ipairs(player.getAccounts()) do
        if Config.EnableAccounts[account.name] then
            if account.money > 0 then
                return true
            end
        end
    end

    return false
end


function getLoot(id)
    local player = ESX.GetPlayerFromId(id)

    local found = {}

    -- ITEMS --

    for _, item in pairs(player.getInventory()) do
        local count = item.count

        if count > 0 and item.canRemove then
            local data = {
                value = item.count,
                min = 1,
                max = item.count,
                label = item.label,
                type = 'slider',
                kind = 'item',
                name = item.name,
            }

            table.insert(found, data)
        end
    end

    -- WEAPONS --

    for _, weap in ipairs(player.getLoadout()) do
        local data = {
            value = 1,
            min = 1,
            max = 1,
            label = weap.label,
            type = 'slider',
            kind = 'weapon',
            name = weap.name,

            ammo = weap.ammo,
        }

        table.insert(found, data)
    end

    -- MONEY --

    local money = player.getMoney()

    if money > 0 then
        local data = {
            value = money,
            min = 1,
            max = money,
            label = _U('money'),
            type = 'slider',
            kind = 'money',
        }

        table.insert(found, data)
    end

    -- ACCOUNTS --

    for _, account in ipairs(player.getAccounts()) do
        if Config.EnableAccounts[account.name] then
            if account.money > 0 then
                local data = {
                    value = account.money,
                    min = 1,
                    max = account.money,
                    label = _U(account.name),
                    type = 'slider',
                    kind = 'account',
                    name = account.name,
                }

                table.insert(found, data)
            end
        end
    end

    -- ETC --

    if #found > 0 then
        local data = {
            label = _U('loot all'),
            kind = 'all',
        }

        table.insert(found, data)
    end

    return found
end
