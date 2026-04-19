function setupEnemyTypes()
    local ENEMY_TYPE_ASSOCIATION = Global.getTable("ENEMY_TYPE_ASSOCIATION")
    if ENEMY_TYPE_ASSOCIATION == nil then
        ENEMY_TYPE_ASSOCIATION = {}
    end

    for act = 1, 3 do
        local deck = getObjectFromGUID(enemy_deck_guid[act])
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            table.insert(ENEMY_TYPE_ASSOCIATION[act]["Encounters"], v.guid)
        end
    end

    for act = 1, 3 do
        local deck = getObjectFromGUID(summon_deck_guid[act])
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            table.insert(ENEMY_TYPE_ASSOCIATION[act]["Summons"], v.guid)
        end
    end

    for act = 1, 3 do
        local deck = getObjectFromGUID(elite_deck_guid[act])
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            table.insert(ENEMY_TYPE_ASSOCIATION[act]["Elites"], v.guid)
        end
    end

    Global.setTable("ENEMY_TYPE_ASSOCIATION", ENEMY_TYPE_ASSOCIATION)
end
