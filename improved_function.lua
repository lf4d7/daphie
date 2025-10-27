-- Improved version of the spawned function with clearer code structure
spawn(function()
    while task.wait(5) do
        -- Check if we have any whitelisted pets
        local whitelistedPets = getWhitelistedPets()
        local hasValidTargets = checkForValidTargets()
        
        -- Only proceed if we're not currently stealing
        if not STEALING then
            -- If no valid targets are present and we have pets
            if not hasValidTargets and #whitelistedPets > 0 then
                -- Server hop if there are enough players
                if shouldServerHop() then
                    task.wait(1)
                    spawn(ServerHop)
                end
            end
        end
    end
end)

-- Helper function to get whitelisted pets from inventory
function getWhitelistedPets()
    local whitelistedPets = {}
    local petInventory = dataModule:GetData().PetsData.PetInventory.Data
    
    for petUid, petData in pairs(petInventory) do
        if checkPetsWhilelist(petData.PetType) then
            table.insert(whitelistedPets, petData.PetType)
        end
    end
    
    return whitelistedPets
end

-- Helper function to check if there are valid targets (stealable players)
function checkForValidTargets()
    local players = game.Players:GetPlayers()
    
    for _, player in pairs(players) do
        if shall_steal(player) then
            return true
        end
    end
    
    return false
end

-- Helper function to determine if we should server hop
function shouldServerHop()
    local playerCount = #game.Players:GetPlayers()
    return playerCount >= 5
end