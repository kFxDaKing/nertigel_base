function makeLoadout(id, player)
    local self = {
        id = id,
        player = player,
        data = player.loadout,
        changed = false,
    }

    function self.remove(name)
        for i, weapon in ipairs(self.data) do
            if weapon.name == name then
                table.remove(self.data, i)
                self.changed = true
                return
            end
        end

        print('Cannot remove weapon "' .. name .. '" from loadout.')
    end

    function self.update()
        if self.changed then
            self.player.loadout = self.data
            TriggerClientEvent('loot2:c:updateLoadout', self.id, self.data)
        end
    end

    return self
end
