Config = {}

Config.Locale = 'en'

Config.EnableMoney      = true                      -- Allows you to loot money.
Config.EnableInventory  = true                      -- Allows you to loot items.
Config.EnableLoadout    = true                      -- Allows you to loot weapons.

Config.EnableAccounts = {
    ['black_money']     = true,                     -- Allows you to loot dirty money.
}

Config.MarkerDistance   = 15.0                      -- Minimum distance to show the marker.
Config.MarkerType       = 29                        -- Marker type (https://docs.fivem.net/game-references/markers/).
Config.MarkerHeight     = 0.8                       -- Height of the marker, in relation to the player's body.
Config.MarkerColor      = {100, 255, 100, 100}      -- Marker color (RGBA).
Config.MarkerScale      = 0.5                       -- Marker size.

Config.LootDistance     = 1.8                       -- Minimum distance to loot.
Config.LootSpeed        = 0.4                       -- Maximum speed of the player's body to be looted (m/s).
Config.LootInputName    = 'INPUT_PICKUP'            -- Input name (https://docs.fivem.net/game-references/controls/).
Config.LootInputCode    = 38                        -- Input code to loot.
Config.LootAnimation    = 'CODE_HUMAN_MEDIC_KNEEL'  -- Looting animation.

Config.EnableHelpText   = true                      -- Displays the help text in the upper left corner.
Config.UsePNotify       = false                     -- Use pNotify to show notifications.

Config.MenuType         = 'inventory'               -- It doesn't work yet ...

-- Allow looting only to certain ace groups, put their names here.
-- Empty means that all groups are allowed. 
-- Ex: {admin = true}
Config.AllowedGroups    = {}

-- Allow looting only to certain jobs, put job names here.
-- Empty means that all jobs are allowed.
-- Ex: { police = true }
Config.AllowedJobs      = {}

-- Script ranges. You probably don't need to change this.
-- Using a lower value makes lootage more fluid, but weighs more.
Config.SearchInterval   = 200
Config.CheckInterval    = 100
