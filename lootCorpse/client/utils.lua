function showNotification(ESX, text, color)
    if Config.UsePNotify then
        TriggerEvent('pNotify:SendNotification', {
            type = color == 'r' and 'error' or 'info',
            text = text,
        })
    else
        ESX.ShowNotification('~' .. color .. '~' .. text)
    end
end

function showHelpText(text)
    if Config.EnableHelpText then
        SetTextComponentFormat('STRING')
        AddTextComponentString(text)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end
end

function showMarker(type, x, y, z, scale, r, g, b, a)
    DrawMarker(
        type,
        x, y, z,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        scale, scale, scale,
        r, g, b, a,
        true, true, 2, false,  -- PUT SOME IN THE CONFIG
        nil, nil, false
    )
end

function getDistance(e1, e2)
    local p1 = GetEntityCoords(e1)
    local p2 = GetEntityCoords(e2)
    return GetDistanceBetweenCoords(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z)
end

-- EXPERIMENTAL --

-- Returns remainder
function addAmmo(ped, name, ammo)
    local hash = GetHashKey(name)
    local ped = PlayerPedId()
    local _, max = GetMaxAmmo(ped, hash)
    local total = GetAmmoInPedWeapon(ped, hash) + ammo

    if total > max then
        SetPedAmmo(ped, hash, max)
        return max - total
    else
        SetPedAmmo(ped, hash, total)
        return 0
    end
end
