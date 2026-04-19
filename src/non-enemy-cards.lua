function unpackNonEnemyCards()
    local pos = self.getPosition()
    local decks = {}
    local standard_rotation = {0, 180, 0}
    local i = 0

    for sts_guid, mod_guid in pairs(non_enemy_decks) do
        i = i + 1
        local sts_deck = getObjectFromGUID(sts_guid)
        self.takeObject({
            guid = mod_guid,
            smooth = false,
            position = {
                x = pos[1] + 2.5 * (i % 6 - 2.5),
                y = pos[2] + 2,
                z = pos[3] - 3.5 * (math.floor(i / 6) - 2.5)
            },
            callback_function = function(o)
                o.setLock(true)
                local sts_rot = sts_deck.getRotation()
                sts_deck.setRotation(standard_rotation)
                table.insert(decks, {sts_deck, o, sts_rot})
            end
        })
    end

    -- Wait for all objects to finish spawning before merging them into decks
    Wait.condition(function()
        for _, deck in pairs(decks) do
            deck[2].setLock(false)
            deck[1].putObject(deck[2])
            deck[1].setRotation(deck[3])
        end
    end, function()
        local check = true
        for _, deck in pairs(decks) do
            if deck[2].spawning or deck[2].loading_custom then
                check = false
                break
            end
        end
        return check
    end)
end
