print("Nertigel's Base Loaded.")

dependency 'es_extended'

client_scripts {
  	-- base
  	'@es_extended/locale.lua',

	-- med System
	'medSystem/client.lua',

	-- cocaine System
	'cocaineSystem/config.lua',
	'cocaineSystem/client.lua',

	-- loot Corpse
	'lootCorpse/locales/en.lua',
    'lootCorpse/locales/br.lua',
    'lootCorpse/config.lua',
    'lootCorpse/client/utils.lua',
    'lootCorpse/client/main.lua',
}

server_scripts {
	-- base
	'@es_extended/locale.lua',

	-- med System
	'medSystem/server.lua',

	-- cocaine System
	'cocaineSystem/server.lua',

	-- loot Corpse
	'lootCorpse/locales/en.lua',
    'lootCorpse/locales/br.lua',
    'lootCorpse/config.lua',
    'lootCorpse/server/shared.lua',
    'lootCorpse/server/loadout.lua',
    'lootCorpse/server/main.lua',
}
