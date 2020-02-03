local function notify(target, text)
    if Config.UsePNotify then
        TriggerClientEvent('pNotify:SendNotification', target, {
            type = 'warning',
            text = text,
        })
    else
        TriggerClientEvent('esx:showNotification', target,
            '~r~' .. text
        )
    end
end


local function sendMenuUpdate(source, target)
    local loot = getLoot(target)

    if #loot > 0 then
        TriggerClientEvent('loot2:c:modify', source, target, loot)
    else
        TriggerClientEvent('loot2:c:fail', source, 'empty')

        notify(target, _U('all looted'))
    end
end


RegisterNetEvent('loot2:s:filter')
AddEventHandler('loot2:s:filter',
    function(candidates)
        local found = {}

        for _, player in ipairs(candidates) do
            if canLoot(player) then
                table.insert(found, player)
            end
        end

        TriggerClientEvent('loot2:c:filtered', source, found)
    end)


RegisterNetEvent('loot2:s:get')
AddEventHandler('loot2:s:get',
    function(target)
        -- TODO: Improve this. Hide looting interface.
        if not hasLootPermission(source) then
            TriggerClientEvent('loot2:c:fail', source, 'forbidden')
            return
        end

        if isLocked(target) then
            TriggerClientEvent('loot2:c:fail', source, 'locked')
            return
        else
            setLock(target, true)  -- source
        end

        local data = getLoot(target)

        TriggerClientEvent('loot2:c:got', source, data)

        notify(target, _U('being looted'))
    end)


RegisterNetEvent('loot2:s:free')
AddEventHandler('loot2:s:free',
    function(target)
        -- if not isLocked(target) then
        --     print('debug - esx_loot2 - double free: ' .. target)
        -- end

        setLock(target, false)
    end)


RegisterNetEvent('loot2:s:lootItem')
AddEventHandler('loot2:s:lootItem',
    function(target, name, count)
        local sPlayer = ESX.GetPlayerFromId(source)
        local tPlayer = ESX.GetPlayerFromId(target)

        tPlayer.removeInventoryItem(name, count)
        sPlayer.addInventoryItem(name, count)

        sendMenuUpdate(source, target)
    end)

RegisterNetEvent('loot2:s:lootWeapon')
AddEventHandler('loot2:s:lootWeapon',
    function(target, name, removeAmmo)
        local sPlayer = ESX.GetPlayerFromId(source)
        local tPlayer = ESX.GetPlayerFromId(target)

        local loadout = makeLoadout(target, tPlayer)

        tPlayer.removeWeapon(name, removeAmmo)
        sPlayer.addWeapon(name)

        loadout.remove(name)
        loadout.update()

        sendMenuUpdate(source, target)
    end)

RegisterNetEvent('loot2:s:lootMoney')
AddEventHandler('loot2:s:lootMoney',
    function(target, count)
        local sPlayer = ESX.GetPlayerFromId(source)
        local tPlayer = ESX.GetPlayerFromId(target)

        -- TODO: Notification
        tPlayer.removeMoney(count)
        sPlayer.addMoney(count)

        sendMenuUpdate(source, target)

        notify(target, _U('money looted', ESX.Math.GroupDigits(count)))
    end)

RegisterNetEvent('loot2:s:lootAccount')
AddEventHandler('loot2:s:lootAccount',
    function(target, name, count)
        local sPlayer = ESX.GetPlayerFromId(source)
        local tPlayer = ESX.GetPlayerFromId(target)

        tPlayer.removeAccountMoney(name, count)
        sPlayer.addAccountMoney(name, count)

        sendMenuUpdate(source, target)

        notify(target, _U('account looted', ESX.Math.GroupDigits(count), _U(name)))
    end)

RegisterNetEvent('loot2:s:lootAll')
AddEventHandler('loot2:s:lootAll',
    function(target)
        local sPlayer = ESX.GetPlayerFromId(source)
        local tPlayer = ESX.GetPlayerFromId(target)

        -- Workaround for the weapon loadout bug...
        local loadout = makeLoadout(target, tPlayer)

        for _, item in ipairs(getLoot(target)) do
            if item.kind == 'money' then
                tPlayer.removeMoney(item.value)
                sPlayer.addMoney(item.value)
            elseif item.kind == 'weapon' then
                tPlayer.removeWeapon(item.name)
                sPlayer.addWeapon(item.name, item.value)

                loadout.remove(item.name)
            elseif item.kind == 'item' then
                tPlayer.removeInventoryItem(item.name, item.value)
                sPlayer.addInventoryItem(item.name, item.value)
            elseif item.kind == 'account' then
                tPlayer.removeAccountMoney(item.name, item.value)
                sPlayer.addAccountMoney(item.name, item.value)
            end
        end

        loadout.update()

        sendMenuUpdate(source, target)
        -- TriggerClientEvent('loot2:c:fail', source, 'done')
    end)
