Config = {}

Config.PickupBlip = {x = -1882.2  , y = 2132.48 ,z = 127.61} -- leaf pickup
Config.Processing = {x = 1952.73 , y = 5180.81 ,z = 46.98}

Config.LeafPickup = math.random(1,5)
Config.LeavesPerBag = 10
Config.BagsPerKilo = 25

Config.Zones = { --leaves to bag
	vector3(1957.0, 5162.0, 46.87),
}

Config.Zones2 = { --bags to pooch/kilo
	vector3(1392.49, 1130.27, 108.76), --ranch gang house
	vector3(-1516.05, 126.24, 49.06), --pb mansion gang house
	vector3(1932.47, 4612.29, 39.48), --stash barn cartel gang spot
    vector3(996.75, -116.91, 73.07), --Lost MC cartel gang spot
}