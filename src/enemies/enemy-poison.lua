function getPoisonTokens()
    -- Silent's bag
    local bag = getObjectFromGUID(sts_silent_bag_guid)
    local token_guids = sts_silent_poison_guids

    -- We wary the x and z positions to
    -- make the stack "look nice" on the table. ;)
    local xpos = {17.25, 17.33, 17.41}
    local zpos = {3.24, 3.16, 3.24}
    local rot = {0, 180, 0}

    -- We bring out 3 tokens
    for i = 1, 3 do
        local pos = {
            x = xpos[i], 
            y = 1.05 + (i-1) * 0.15,
            z = zpos[i]
        }
        bag.takeObject({
            guid = token_guids[i],
            position = pos,
            rotation = rot
        })
    end
end

function createPoisonTokens()
    -- We wary the x and z positions to
    -- make the stack "look nice" on the table. ;)
    local xpos = {17.25, 17.33, 17.41}
    local zpos = {3.24, 3.16, 3.24}
    local rot = {0, 180, 0}

    -- We bring out 3 tokens
    for i = 1, 3 do
        local pos = {
            x = xpos[i], 
            y = 1.05 + (i-1) * 0.15,
            z = zpos[i]
        }
        local token = createCustomPoisonToken()
        token.setPosition(pos)
        token.setRotation(rot)
    end
end

function createCustomPoisonToken()
    local token = spawnObject({
        type = "Custom_Token",
        position = {21.3710842, 1.01000035, 22.40111},
        rotation = {0, 180, 0},
        scale = {0.318644583, 1.0, 0.318644583},
        callback_function = function(spawned_object)
            log("Custom poison token spawned: " .. spawned_object.getGUID())
        end
    })
    token.setCustomObject({
        image = "https://steamusercontent-a.akamaihd.net/ugc/1857175596587634153/C3A7B3D1345B8B7F0F2ABF60596D3AA184165FED/",
        thickness = 0.1,
        merge_disctance = 10,
        stackable = false
    })
    return token
end