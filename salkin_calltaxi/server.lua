local ESX = exports["es_extended"]:getSharedObject()

-- Event: Kunde ruft Taxi
RegisterNetEvent('salkin_taxi:requestTaxi')
AddEventHandler('salkin_taxi:requestTaxi', function(coords)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    local taxiFound = false

    if not xPlayer then return end

    -- Alle Spieler durchlaufen
    for i=1, #xPlayers, 1 do
        local xTarget = ESX.GetPlayerFromId(xPlayers[i])
        if xTarget and xTarget.job.name == 'taxi' then
            -- Anfrage an alle Taxifahrer senden
            TriggerClientEvent('salkin_taxi:receiveRequest', xPlayers[i], _source, coords, xPlayer.getName())
            taxiFound = true
        end
    end

    if not taxiFound then
        TriggerClientEvent('esx:showNotification', _source, 'Es ist momentan kein Taxifahrer im Dienst.', 'error')
    end
end)

-- Event: Fahrer nimmt Auftrag an
RegisterNetEvent('salkin_taxi:acceptCall')
AddEventHandler('salkin_taxi:acceptCall', function(targetId)
    local _source = source
    local xDriver = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if xTarget then
        -- Koordinaten des Kunden holen
        local targetPed = GetPlayerPed(targetId)
        local targetCoords = GetEntityCoords(targetPed)

        -- Wegpunkt beim Fahrer setzen
        TriggerClientEvent('salkin_taxi:setWaypoint', _source, targetCoords)

        -- Dem Kunden Bescheid geben
        TriggerClientEvent('salkin_taxi:taxiAccepted', targetId, xDriver.getName())
    else
        TriggerClientEvent('esx:showNotification', _source, 'Der Kunde ist nicht mehr erreichbar.', 'error')
    end
end)