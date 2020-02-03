local ESX

-- Table of closeby players.
-- Includes all players either within the marker distance or the loot distance.
local nearbyPlayers = {}

-- When this is true, we stop searching for nearby players.
-- We check if the loot target is still within range, etc.
local looting = false

-- The player we're currently looting, if looting == true.
local lootPlayer, lootPed

-- Safety measure...
local freeze = false


local function checkLoot(range)
    local user = PlayerPedId()
    local pos = GetEntityCoords(user)
    local nearby = ESX.Game.GetPlayersInArea(pos, range)

    if #nearby == 0 then
        nearbyPlayers = {}
        return
    end

    local ids = {}

    for _, player in ipairs(nearby) do
        local ped = GetPlayerPed(player)

        if user ~= ped and DoesEntityExist(ped) then
            if IsPedDeadOrDying(ped) and GetEntitySpeed(ped) <= Config.LootSpeed then
                table.insert(ids, GetPlayerServerId(player))
            end
        end
    end

    if #ids == 0 then
        nearbyPlayers = {}
        return
    end

    TriggerServerEvent('loot2:s:filter', ids)
end


local function checkStop()
    -- if lootPlayer == nil then
    --     return true
    -- end

    if IsPlayerDead(PlayerId()) then
        return true
    end

    if not IsPlayerDead(lootPlayer) then
        return true
    end

    if not DoesEntityExist(lootPed) then
        return true
    end

    local ped = PlayerPedId()
    local dist = getDistance(ped, lootPed)

    if dist > Config.LootDistance then
        return true
    end

    if GetEntitySpeed(lootPed) > Config.LootSpeed then
        return true
    end

    return false
end


local function tickNotLooting()
    if freeze then
        return false
    end

    if IsPlayerDead(PlayerId()) then
        return false
    end

    local user = PlayerPedId()

    local closestPlayer
    local closestPed
    local closestDistance

    if #nearbyPlayers == 0 then
        return false
    end

    for _, player in ipairs(nearbyPlayers) do
        local ped = GetPlayerPed(player)
        local pos = GetEntityCoords(ped)
        local dist = getDistance(user, ped)

        if dist <= Config.MarkerDistance then
            showMarker(
                Config.MarkerType,
                pos.x, pos.y, pos.z + Config.MarkerHeight,
                Config.MarkerScale,
                table.unpack(Config.MarkerColor)
            )
        end

        if closestPlayer == nil or dist < closestDistance then
            closestPlayer = player
            closestPed = ped
            closestDistance = dist
        end
    end

    if closestDistance <= Config.LootDistance then
        showHelpText(_U('press to loot', '~' .. Config.LootInputName .. '~'))

        if IsControlJustPressed(0, Config.LootInputCode) then
            looting = true

            lootPlayer = closestPlayer
            lootPed = closestPed

            TriggerServerEvent('loot2:s:get', GetPlayerServerId(lootPlayer))
        end
    end

    return true
end


local function stopLooting(silent, noFree)
    freeze = true

    looting = false

    ESX.UI.Menu.CloseAll()

    if not silent then
        showNotification(ESX, _U('stop looting'), 's')
    end

    if not noFree then
        TriggerServerEvent('loot2:s:free', GetPlayerServerId(lootPlayer))
    end

    ClearPedTasks(PlayerPedId())

    Citizen.Wait(1000)

    freeze = false
end


local function tickLooting()
    if checkStop() then
        stopLooting()
    end
end


local function showLootMenu(data)
    ESX.UI.Menu.Open(
        'default',
        GetCurrentResourceName(),
        Config.MenuType,
        {
            title = _U('loot inventory'),
            align = 'bottom-right',
            elements = data,
        },
        function(data, menu)
            local item = data.current
            local id = GetPlayerServerId(lootPlayer)

            ESX.UI.Menu.CloseAll()  -- ?

            if item.kind == 'all' then
                TriggerServerEvent('loot2:s:lootAll', id)
            elseif item.value > 0 then
                if item.kind == 'item' then
                    TriggerServerEvent('loot2:s:lootItem', id, item.name, item.value)
                elseif item.kind == 'weapon' then
                    local rest = addAmmo(ped, item.name, item.ammo)
                    TriggerServerEvent('loot2:s:lootWeapon', id, item.name, item.ammo - rest)
                elseif item.kind == 'money' then
                    TriggerServerEvent('loot2:s:lootMoney', id, item.value)
                elseif item.kind == 'account' then
                    TriggerServerEvent('loot2:s:lootAccount', id, item.name, item.value)
                end
            end
        end,
        function(data, menu)
            stopLooting()
        end)
end


RegisterNetEvent('loot2:c:filtered')
AddEventHandler('loot2:c:filtered',
    function(ids)
        local tab = {}

        for _, id in ipairs(ids) do
            table.insert(tab, GetPlayerFromServerId(id))
        end

        nearbyPlayers = tab
    end)

RegisterNetEvent('loot2:c:got')
AddEventHandler('loot2:c:got',
    function(data)
        TaskStartScenarioInPlace(PlayerPedId(), Config.LootAnimation, 0, false)
        ESX.UI.Menu.CloseAll()
        showLootMenu(data)
    end)

RegisterNetEvent('loot2:c:fail')
AddEventHandler('loot2:c:fail',
    function(reason)
        if reason == 'locked' then
            stopLooting(true, true)
            showNotification(ESX, _U('already looting'), 'r')
        elseif reason == 'forbidden' then
            stopLooting(true)
            showNotification(ESX, _U('forbidden'), 'r')
        else
            stopLooting()
        end
    end)

RegisterNetEvent('loot2:c:updateLoadout')
AddEventHandler('loot2:c:updateLoadout',
    function(loadout)
        -- Fixes the loadout problems.
        ESX.SetPlayerData('loadout', loadout)
    end)

RegisterNetEvent('loot2:c:modify')
AddEventHandler('loot2:c:modify',
    function(id, data)
        local player = GetPlayerFromServerId(id)

        if looting and lootPlayer == player then
            showLootMenu(data)
        else
            stopLooting()
        end
    end)

-- If the player is locked for some reason, e.g. disconnection from the looter.
AddEventHandler('esx:onPlayerDeath',
    function()
        local ped = PlayerPedId()

        while IsPedDeadOrDying(ped) do
            Citizen.Wait(100)
        end

        Citizen.Wait(1000)

        TriggerServerEvent('loot2:s:free', GetPlayerServerId(PlayerId()))
    end)


Citizen.CreateThread(
    function()
        while not ESX do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(100)
        end
    end)

Citizen.CreateThread(
    function()
        while not ESX do
            Citizen.Wait(200)
        end

        while true do
            if looting then
                tickLooting()
                Citizen.Wait(Config.CheckInterval)
            elseif tickNotLooting() then
                Citizen.Wait(1)
            else
                Citizen.Wait(Config.CheckInterval)
            end
        end
    end)

Citizen.CreateThread(
    function()
        while not ESX do
            Citizen.Wait(200)
        end

        local range = math.max(Config.MarkerDistance, Config.LootDistance)

        while true do
            if not looting then
                checkLoot(range)
            end

            Citizen.Wait(Config.SearchInterval)
        end
    end)
