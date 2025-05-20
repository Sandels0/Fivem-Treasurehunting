local treasureCoords = vector3(-2117.8044, -501.1856, 3.0811)
local digging = false
local shown = false
local treasureBlip = nil
local treasureBlipRadius = nil
local lastDigCoords = nil
local MIN_DISTANCE = 5.0

CreateThread(function()
    treasureBlipRadius = AddBlipForRadius(treasureCoords.x, treasureCoords.y, treasureCoords.z, 50.0)
    SetBlipHighDetail(treasureBlipRadius, true)
    SetBlipColour(treasureBlipRadius, 60) 
    SetBlipAlpha(treasureBlipRadius, 128)

    treasureBlip = AddBlipForCoord(treasureCoords)
    SetBlipSprite(treasureBlip, 587) 
    SetBlipDisplay(treasureBlip, 4)
    SetBlipScale(treasureBlip, 0.9)
    SetBlipColour(treasureBlip, 60)
    SetBlipAsShortRange(treasureBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Aarteen kaivuu")
    EndTextCommandSetBlipName(treasureBlip)
end)

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - treasureCoords)

        if distance < 20.0 and not digging then
            if not shown then
                lib.showTextUI('[E] - Kaiva aarre')
                shown = true
            end

            if IsControlJustPressed(0, 38) then -- E
                startDigging()
            end
        else
            if shown then
                lib.hideTextUI()
                shown = false
            end
        end
    end
end)

function startDigging()
    local playerCoords = GetEntityCoords(PlayerPedId())

    if lastDigCoords and #(playerCoords - lastDigCoords) < MIN_DISTANCE then
        lib.notify({
            title = 'Liian lähellä',
            description = 'Liiku kauemmas kaivaaksesi lisää.',
            type = 'error'
        })
        return
    end

    lib.hideTextUI()

    ESX.TriggerServerCallback('esx_treasurehunt:hasShovel', function(hasShovel)
        if not hasShovel then
            lib.notify({
                title = 'Ei lapiota!',
                description = 'Tarvitset lapiota kaivaaksesi aarteen.',
                type = 'error'
            })
            return
        end

        local success = lib.skillCheck({'easy', 'medium', 'medium'}, {'w', 'a', 's', 'd'})

        if not success then
            lib.notify({
                title = 'Epäonnistui!',
                description = 'Et onnistunut aloittamaan kaivamista.',
                type = 'error'
            })
            return
        end


        digging = true
        local playerPed = PlayerPedId()

        TaskStartScenarioInPlace(playerPed, "world_human_gardener_plant", 0, true)

        lib.progressCircle({
            duration = 7000,
            label = 'Kaivetaan aarretta...',
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                car = true,
                combat = true
            }
        })

        ClearPedTasks(playerPed)
        TriggerServerEvent('esx_treasurehunt:giveTreasure')

        lib.notify({
            title = 'Onnistui!',
            description = 'Kaivoit aarteen esiin!',
            type = 'success'
        })

        lastDigCoords = playerCoords
        digging = false
    end)
end
