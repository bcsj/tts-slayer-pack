function shuffleInUpgradeCards(n)
    -- Pull upgrade card from bag and when ready
    -- clone it a number of times and add
    local upgCard = unpackUpgradeCard()
    whenReady({upgCard}, function()
        local pos = upgCard.getPosition()
        local target_decks = {
            IRONCLAD_REWARD_DECK_GUID,
            IRONCLAD_REWARD_DECK_UPG_GUID,
            SILENT_REWARD_DECK_GUID,
            SILENT_REWARD_DECK_UPG_GUID,
            DEFECT_REWARD_DECK_GUID,
            DEFECT_REWARD_DECK_UPG_GUID,
            WATCHER_REWARD_DECK_GUID,
            WATCHER_REWARD_DECK_UPG_GUID,
            COLORLESS_REWARD_DECK_GUID,
            COLORLESS_REWARD_DECK_UPG_GUID
        }
        local clones = {}
        local deck_clones_map = {}

        -- Spawn n clones of the upgrade card for each target deck
        local grid = cardGridGenerator(pos, {
            cols = 4, 
            rows = 3, 
            y_offset = 0.5
        })

        local c = 0
        for _, deck_guid in pairs(target_decks) do
            local deck = getObjectFromGUID(deck_guid)
            local deck_clones = {}
            for i = 1, n do
                local upgCardClone = upgCard.clone()
                upgCardClone.setPosition(grid(c))
                table.insert(clones, upgCardClone)
                table.insert(deck_clones, upgCardClone.getGUID())
                c = c + 1
            end
            deck_clones_map[deck_guid] = deck_clones
        end

        -- Pack away the original upgrade card again
        upgCard.setLock(false)
        self.putObject(upgCard)

        -- When clones are spawned and ready, shuffle them into the decks
        whenReady(clones, function()
            for _, deck_guid in pairs(target_decks) do
                local deck = getObjectFromGUID(deck_guid)
                for _, clone_guid in pairs(deck_clones_map[deck_guid]) do
                    local clone = getObjectFromGUID(clone_guid)
                    clone.setLock(false)
                    local rot = deck.getRotation()
                    deck.setRotation({0, 180, 0})
                    deck.putObject(clone)
                    deck.setRotation(rot)
                end
                deck.shuffle()
            end
        end)
    end)
end

function unpackUpgradeCard()
    local pos = self.getPosition()
    return self.takeObject({
        guid = non_enemy_upg_card,
        smooth = false,
        position = {
            x = pos[1],
            y = pos[2] + 4,
            z = pos[3]
        },
        callback_function = function(o)
            o.setLock(true)
        end
    })
end