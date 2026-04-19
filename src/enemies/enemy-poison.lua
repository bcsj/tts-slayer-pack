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