ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("KCoke:get")
AddEventHandler("KCoke:get", function()
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getInventoryItem('cokeleaf').count <= 1000 then
		xPlayer.addInventoryItem('cokeleaf', Config.LeafPickup)
	else
		TriggerClientEvent('esx:showNotification', source, '~r~You cant hold any more coca leaves')
	end	
end)

RegisterServerEvent("KCoke:bag")
AddEventHandler("KCoke:bag", function()
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getInventoryItem('cokeleaf').count >= Config.LeavesPerBag then
		xPlayer.removeInventoryItem('cokeleaf', Config.LeavesPerBag) 
		xPlayer.addInventoryItem('coke', 1) 
	else
		TriggerClientEvent('esx:showNotification', source, '~r~Not enough coca leaves')
	end	
end)

RegisterServerEvent("KCoke:bagging")
AddEventHandler("KCoke:bagging", function()
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getInventoryItem('coke').count >= Config.BagsPerKilo then
		xPlayer.removeInventoryItem('coke', Config.BagsPerKilo) 
		xPlayer.addInventoryItem('coke_pooch', 1) 
	else
		TriggerClientEvent('esx:showNotification', source, '~r~Not enough coke bags')
	end	
end)

RegisterServerEvent("KCoke:processing")
AddEventHandler("KCoke:processing", function()
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getInventoryItem('cokeleaf').count >= Config.LeavesPerBag then
		xPlayer.removeInventoryItem('cokeleaf', Config.LeavesPerBag) 
		xPlayer.addInventoryItem('coke', 1) 
	else
		TriggerClientEvent('esx:showNotification', source, '~r~Not enough coca leaves')
	end	
end)