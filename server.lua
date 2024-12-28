local QBCore = exports['qb-core']:GetCoreObject()

-- Event to remove money from the player
RegisterServerEvent('kvl:removemoney')
AddEventHandler('kvl:removemoney', function(price)
    local source = source
    local playerId = source
    local xPlayer = QBCore.Functions.GetPlayer(playerId)

    if xPlayer then
        QBCore.Functions.RemoveMoney(playerId, price)
    end
end)

