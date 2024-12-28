local QBCore = exports['qb-core']:GetCoreObject()
local qbTarget = exports['qb-target']

local LegalDoc = false
local IllegalDoc = false

for k, v in pairs(KVL['Doctors'].Legal) do
    qbTarget.AddSphereZone({
        name = 'Revive' .. k,
        coords = v.coords,
        radius = 0.45,
        debug = drawZones,
        options = {
            {
                name = 'revive',
                label = 'Revive ' .. KVL['Prices'].LegalPrice .. '$',
                onSelect = function()
                    LegalDoc = true
                    MoneyCheck()
                end
            }
        },
    })
end

for k, v in pairs(KVL['Doctors'].Illegal) do
    qbTarget.AddSphereZone({
        name = 'Revive' .. k,
        coords = v.coords,
        radius = 0.45,
        debug = drawZones,
        options = {
            {
                name = 'revive',
                label = 'Revive ' .. KVL['Prices'].IllegalPrice .. '$',
                onSelect = function()
                    IllegalDoc = true
                    MoneyCheck()
                end
            }
        },
    })
end

RegisterNetEvent('kvl:givehealth', function()
    local playerId = PlayerId()
    if GetEntityHealth(PlayerPedId()) == 0 then
        FreezeEntityPosition(PlayerPedId(), true)
        if KVL.OX then
            if lib.progressBar({
                duration = 10000,
                label = 'You are being treated',
                useWhileDead = true,
                canCancel = true,
                disable = {
                    car = true,
                },
            }) then
                FreezeEntityPosition(PlayerPedId(), false)
                QBCore.Functions.TriggerCallback('qb-ambulancejob:revive', function(result)
                    if result then
                        QBCore.Functions.SetDeathStatus(playerId, false)
                    end
                end)
            else
                -- Handle cancellation
            end
        else
            FreezeEntityPosition(PlayerPedId(), false)
            QBCore.Functions.TriggerCallback('qb-ambulancejob:revive', function(result)
                if result then
                    QBCore.Functions.SetDeathStatus(playerId, false)
                end
            end)
        end
    else
        FreezeEntityPosition(PlayerPedId(), true)
        if KVL.OX then
            if lib.progressBar({
                duration = 5000,
                label = 'You are being treated',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
            }) then
                FreezeEntityPosition(PlayerPedId(), false)
                SetEntityHealth(PlayerPedId(), 200)
            else
                -- Handle cancellation
            end
        else
            FreezeEntityPosition(PlayerPedId(), false)
            SetEntityHealth(PlayerPedId(), 200)
        end
    end
end)

function MoneyCheck()
    if LegalDoc then
        LegalDoc = false
        QBCore.Functions.TriggerCallback('kvl-rob:paracheckk', function(paracheckk)
            if paracheckk then
                QBCore.Functions.RemoveMoney(PlayerId(), KVL['Prices']['LegalPrice'])
                TriggerEvent('kvl:givehealth')
            else
                QBCore.Functions.Notify(PlayerId(), 'You do not have enough money for a legal revival!', 'error')
            end
        end)
    elseif IllegalDoc then
        -- Similar logic for illegal revival
    end
end
