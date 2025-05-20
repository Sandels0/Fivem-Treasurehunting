ESX.RegisterServerCallback('esx_treasurehunt:hasShovel', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local lapio = xPlayer.getInventoryItem('lapio')

    cb(lapio and lapio.count > 0)
end)

RegisterNetEvent('esx_treasurehunt:giveTreasure', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    local rewards = {
        { item = 'kultaharkko', min = 1, max = 1, chance = 3 },
        { item = 'timanttisormus', min = 1, max = 1, chance = 7 },
        { item = 'timantti', min = 1, max = 1, chance = 15 },
        { item = 'kultakolikko', min = 1, max = 3, chance = 25 },
        { item = 'kivi', min = 1, max = 5, chance = 50 }
    }

    local roll = math.random(1, 100)
    local cumulative = 0
    local selectedReward = rewards[#rewards]

    for _, reward in ipairs(rewards) do
        cumulative = cumulative + reward.chance
        if roll <= cumulative then
            selectedReward = reward
            break
        end
    end

    local amount = math.random(selectedReward.min, selectedReward.max)
    xPlayer.addInventoryItem(selectedReward.item, amount)

    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Aarre löytyi!',
        description = string.format('Löysit %s x%d!', selectedReward.item, amount),
        type = 'success'
    })
end)
