function unpackCharacterCards()
    local characters = {"ironclad", "silent", "defect", "watcher"}
    local pos = self.getPosition()
    local decks = {}
    local standard_rotation = {0, 180, 0}
    for j, char in pairs(characters) do
        for i = 1, 4 do
            local sts_guid = sts_character_cards[char][i]
            local sts_deck = getObjectFromGUID(sts_guid)

            local mod_guid = mod_character_cards[char][i]
            self.takeObject({ 
                guid = mod_guid, 
                smooth = false,
                position = {
                    x = pos[1] + 2.5 * (i - 2.5),
                    y = pos[2] + 2,
                    z = pos[3] - 3.5 * (j - 2.5)
                },
                callback_function = function(o)
                    -- We lock them in place until they are loaded
                    o.setLock(true)
                    local sts_rot = sts_deck.getRotation()
                    sts_deck.setRotation(standard_rotation)
                    table.insert(decks, {sts_deck, o, sts_rot})
                end 
            })
        end
    end

    local char = "other"
    local j = 5
    for i = 1, 6 do
        local sts_guid = sts_character_cards[char][i]
        local sts_deck = getObjectFromGUID(sts_guid)

        local mod_guid = mod_character_cards[char][i]
        self.takeObject({ 
            guid = mod_guid, 
            smooth = false,
            position = {
                x = pos[1] + 2.5 * (i - 3.5),
                y = pos[2] + 2,
                z = pos[3] - 3.5 * (j - 2.5)
            },
            callback_function = function(o) 
                o.setLock(true)
                local sts_rot = sts_deck.getRotation()
                sts_deck.setRotation(standard_rotation)
                table.insert(decks, {sts_deck, o, sts_rot})
            end 
        })
    end

    -- Wait for objects to load properly
    -- before putting them into the decks
    Wait.condition(function() 
        for _, deck in pairs(decks) do
            -- Unlock the cards before putting them into the deck
            --log("Check!")
            deck[2].setLock(false)
            deck[1].putObject(deck[2])
            local rotation = deck[3]
            deck[1].setRotation(rotation)
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