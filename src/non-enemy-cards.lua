function unpackNonEnemyCards()
    local pos = self.getPosition()
    local std_rotation = {0, 180, 0}

    local decksAndRotation = {}
    local modDecks = {}

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
                sts_deck.setRotation(std_rotation)
                table.insert(decksAndRotation, {sts_deck, o, sts_rot})
                table.insert(modDecks, o)
            end
        })
    end

    -- Wait for all objects to finish spawning before merging them into decks
    whenReady(modDecks, function()
        for _, deck in pairs(decksAndRotation) do
            local sts_deck, mod_deck, sts_rot = unpack(deck)
            mod_deck.setLock(false)
            sts_deck.putObject(mod_deck)
            sts_deck.setRotation(sts_rot)
        end
    end)
end
