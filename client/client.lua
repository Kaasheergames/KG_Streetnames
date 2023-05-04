

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)


local directions = {
    { label = 'N', value = 0 - 45},
    { label = 'NW', value = 45 },
    { label = 'W', value = 90 },
    { label = 'SW', value = 135 },
    { label = 'S', value = 180 },
    { label = 'SE', value = 225 },
    { label = 'E', value = 270 },
    { label = 'NE', value = 315 },
    { label = 'N', value = 360 - 45 }
}

local uiVisible = false
local wantsStreetNames = Config.StatusOnStartup

local blacklistedCars = Config.BlacklistedCars or {}

function IsVehicleBlacklisted(vehicleModel)
    for i = 1, #blacklistedCars do
        if GetHashKey(blacklistedCars[i]) == vehicleModel then
            return true
        end
    end
    return false
end

function showUI()
    uiVisible = true
    SendNUIMessage({
        type = 'toggle_ui',
        show = uiVisible
    })
end

function hideUI()
    uiVisible = false
    SendNUIMessage({
        type = 'toggle_ui',
        show = uiVisible
    })
end

local inVehicle = false

Citizen.CreateThread(function()
    hideUI()
    while true do
        Citizen.Wait(0)
        local playerId = PlayerPedId()
        local playerCoords = GetEntityCoords(playerId)
        local streetnamehash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
        local streetname = GetStreetNameFromHashKey(streetnamehash)
        local heading = GetEntityHeading(playerId)
        local headingl
        local zone = GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z)
        local zonename = GetLabelText(zone)

        local playerVehicle = GetVehiclePedIsIn(playerId, false)

        if DoesEntityExist(playerVehicle) and not IsEntityDead(playerVehicle) then
            local vehicleModel = GetEntityModel(playerVehicle)
            if not IsVehicleBlacklisted(vehicleModel) then
                if not inVehicle then
                    inVehicle = true
                    if wantsStreetNames then
                        showUI()
                    end
                end

                if inVehicle then
                    if wantsStreetNames then
                        showUI()
                    else
                        hideUI()
                    end
                end
            else
                if inVehicle then
                    inVehicle = false
                    hideUI()
                end
            end
        else
            if inVehicle then
                inVehicle = false
                hideUI()
            end
        end

        for i = 1, #directions do
            if (heading - directions[i].value < 90) then
                headingl = directions[i].label
                break
            end
        end

        SendNUIMessage({
            type        = 'position',
            streetname1 = streetname,
            heading     = headingl,
            zone2       = zonename,
        })
    end
end)

RegisterCommand('togglestreetnames', function()
    if inVehicle then
        if wantsStreetNames then
            wantsStreetNames = false
            ESX.ShowNotification(_U('togglefalse'))
            hideUI()
        else
            wantsStreetNames = true
            showUI()
            ESX.ShowNotification(_U('toggletrue'))
        end
    else
        ESX.ShowNotification(_U('novehicle'))
    end
end)
TriggerEvent('chat:addSuggestion', '/togglestreetnames', _U('commandtext'))
