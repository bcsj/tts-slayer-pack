function setupEnemyRewards()
    local ENEMY_REWARD_ASSOCIATION = Global.getTable("ENEMY_REWARD_ASSOCIATION")    
    if ENEMY_REWARD_ASSOCIATION == nil then
        ENEMY_REWARD_ASSOCIATION = {}
    end

    -----------------------------------------------
    local enemy_reward_table = {
        { -- Act I
            {"Potion", "Card"},
            {"Gold_1", "Potion", "Card"},
            {"Gold_1", "Potion", "Card"},
            {"Gold_1", "Potion", "Card"},
            {"Gold_2", "Card"},
            {"Gold_2", "Card"},
            {"Gold_1", "Card"},
            {"Gold_2", "Card"},
            {"Gold_2", "Card"}
        },
        { -- Act II
            {"Potion", "Potion", "Card"},
            {"Gold_1", "Potion", "Card"},
            {"Gold_1", "Card"},
            {"Gold_2", "Card"},
            {"Potion", "Card"},
            {"Gold_2", "Card"},
            {"Potion", "Card"},
            {"Gold_1", "Potion", "Card"},
            {"Gold_2", "Card"}
        },
        { -- Act III 
            {"Gold_2", "Potion", "Card"},
            {"Gold_2", "Potion", "Card"},
            {"Gold_2", "Potion", "Card"},
            {"Potion", "Card"},
            {"Gold_2", "Card"},
            {"Gold_1", "Potion", "Card"},
            {"Gold_2", "Card"}
        }
    }

    local elite_reward_table = {
        { -- Act I
            {"Gold_2", "Relic", "Card"}, 
            {"Gold_2", "Relic", "Card"}, 
            {"Gold_2", "Relic", "Card"}, 
            {"Gold_2", "Relic", "Card"}
        },
        { -- Act II
            {"Gold_2", "Relic", "Card Upgraded"}, 
            {"Gold_2", "Relic", "Card Upgraded"}, 
            {"Gold_2", "Relic", "Card Upgraded"}
        },
        { -- Act III
            {"Gold_3", "Relic", "Card Upgraded"}, 
            {"Gold_3", "Relic", "Card Upgraded"}, 
            {"Gold_3", "Relic", "Card Upgraded"}
        }
    }

    -----------------------------------------------
    -- REWARD INFORMATION - ENEMY
    
    for act = 1, 3 do
        local deck = getObjectFromGUID(enemy_deck_guid[act])
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            ENEMY_REWARD_ASSOCIATION[v.guid] = enemy_reward_table[act][i]
        end
    end
    
    for act = 1, 3 do
        local deck = getObjectFromGUID(elite_deck_guid[act])
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            ENEMY_REWARD_ASSOCIATION[v.guid] = elite_reward_table[act][i]
        end
    end

    Global.setTable("ENEMY_REWARD_ASSOCIATION", ENEMY_REWARD_ASSOCIATION)
end