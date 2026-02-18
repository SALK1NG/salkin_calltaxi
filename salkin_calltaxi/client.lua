local ESX = exports["es_extended"]:getSharedObject()
local callActive = false
local currentCallData = nil

-- Befehl zum Rufen des Taxis
RegisterCommand('calltaxi', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    TriggerServerEvent('salkin_taxi:requestTaxi', coords)
    ESX.ShowNotification('Taxi-Anfrage wurde an die Zentrale gesendet!', 'info')
end)

-- Event: Taxi Fahrer erhält Anfrage
RegisterNetEvent('salkin_taxi:receiveRequest')
AddEventHandler('salkin_taxi:receiveRequest', function(targetId, coords, playerName)
    if callActive then return end 

    callActive = true
    currentCallData = {
        targetId = targetId,
        coords = coords
    }

    -- Benachrichtigung für den Fahrer
    ESX.ShowNotification('NEUE ANFRAGE: ' .. playerName .. '\nDrücke [E] zum Annehmen', 'info')
    
    -- Sound abspielen
    PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)

    -- Thread zum Annehmen (15 Sekunden Zeit)
    Citizen.CreateThread(function()
        local timer = 15000
        local timePassed = 0

        while timePassed < timer and callActive do
            Citizen.Wait(0)
            timePassed = timePassed + 10

            -- Hilfe-Text anzeigen (oben links)
            ESX.ShowHelpNotification('Drücke ~INPUT_CONTEXT~ um die Fahrt von ~b~'..playerName..'~s~ anzunehmen')

            if IsControlJustPressed(0, 38) then -- E Taste
                TriggerServerEvent('salkin_taxi:acceptCall', currentCallData.targetId)
                callActive = false
                currentCallData = nil
                return
            end
        end

        if callActive then
            ESX.ShowNotification('Die Fahrtanfrage ist abgelaufen.', 'error')
            callActive = false
            currentCallData = nil
        end
    end)
end)

-- Event: Wegpunkt setzen für den Fahrer
RegisterNetEvent('salkin_taxi:setWaypoint')
AddEventHandler('salkin_taxi:setWaypoint', function(coords)
    SetNewWaypoint(coords.x, coords.y)
    ESX.ShowNotification('Auftrag angenommen! Wegpunkt wurde auf der Karte markiert.', 'success')
end)

-- Event: Benachrichtigung für den Kunden
RegisterNetEvent('salkin_taxi:taxiAccepted')
AddEventHandler('salkin_taxi:taxiAccepted', function(driverName)
    ESX.ShowNotification('Dein Taxi (' .. driverName .. ') ist jetzt unterwegs zu dir!', 'success')
end)