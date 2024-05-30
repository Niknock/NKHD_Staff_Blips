local showBlips = false
local playerBlips = {}

RegisterNetEvent('nkhd_staff:wrongclass')
AddEventHandler('nkhd_staff:wrongclass', function()
    ESX.ShowNotification(_U('wrong_class'), 1000, 'error')
end)

RegisterNetEvent('nkhd_staff:toggleBlips')
AddEventHandler('nkhd_staff:toggleBlips', function()
    showBlips = not showBlips
    if showBlips then
        ESX.ShowNotification(_U('blips_on'), 1000, 'success')
        showAllPlayerBlips()
    else
        ESX.ShowNotification(_U('blips_off'), 1000, 'success')
        removeAllPlayerBlips()
    end
end)

function showAllPlayerBlips()
    Citizen.CreateThread(function()
        while showBlips do
            ESX.TriggerServerCallback('esx_blips:getPlayerInfo', function(playerInfo)
                local playerId = PlayerId()
                local serverId = GetPlayerServerId(playerId)
                for id, info in pairs(playerInfo) do
                    if id ~= serverId then
                        if not playerBlips[id] then
                            local blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
                            SetBlipSprite(blip, 1)
                            ShowHeadingIndicatorOnBlip(blip, true)
                            SetBlipScale(blip, 0.85)
                            SetBlipColour(blip, 0)
                            SetBlipAsShortRange(blip, false)

                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString(info.name)
                            EndTextCommandSetBlipName(blip)

                            playerBlips[id] = blip
                        else
                            local blip = playerBlips[id]
                            SetBlipCoords(blip, info.coords.x, info.coords.y, info.coords.z)
                            SetBlipRotation(blip, math.floor(info.heading))
                        end
                    end
                end
            end)
            Citizen.Wait(1000)
        end
        removeAllPlayerBlips()
    end)
end

function removeAllPlayerBlips()
    for id, blip in pairs(playerBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    playerBlips = {}
end
