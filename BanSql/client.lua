ESX = nil
Citizen.CreateThread(function() while ESX == nil do TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end) Citizen.Wait(0) end end)local spawnSecond = false

RegisterNetEvent('BanSql:Respond')
AddEventHandler('BanSql:Respond', function()
	TriggerServerEvent("BanSql:CheckMe")
end)

RegisterNetEvent('GetName:Bansql')
AddEventHandler('GetName:Bansql', function(joueur)
	GetPlayerName()
end)
--Event Demo

--TriggerServerEvent("BanSql:ICheat")
--TriggerServerEvent("BanSql:ICheat", "Auto-Cheat Custom Reason")

