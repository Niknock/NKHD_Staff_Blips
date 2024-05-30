ESX = nil

if Config.ESX == 'old' then
     TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif Config.ESX == 'new' then
    ESX = exports["es_extended"]:getSharedObject()
else
    print('Wrong ESX Type!')
end

RegisterCommand(Config.Command, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'nkhd_staffblips' then
        TriggerClientEvent('nkhd_staffblips:toggleBlips', source)
    else
        TriggerClientEvent('nkhd_staffblips:wrongclass', source)
    end
end, false)

ESX.RegisterServerCallback('esx_blips:getPlayerInfo', function(source, cb)
    local players = ESX.GetPlayers()
    local playerInfo = {}

    for i = 1, #players do
        local xPlayer = ESX.GetPlayerFromId(players[i])
        if xPlayer then
            local ped = GetPlayerPed(players[i])
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local name = GetPlayerName(players[i])
            playerInfo[players[i]] = {id = players[i], coords = coords, heading = heading, name = name}
        end
    end

    cb(playerInfo)
end)
