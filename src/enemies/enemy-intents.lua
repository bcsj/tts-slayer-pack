function setupEnemyIntents()
    local ENEMY_INTENT_ASSOCIATION = Global.getTable("ENEMY_INTENT_ASSOCIATION")    
    if ENEMY_INTENT_ASSOCIATION == nil then
        ENEMY_INTENT_ASSOCIATION = {}
    end

    local num_players = getNumPlayers()

    -----------------------------------------------
    -- INTENT INFORMATION - ENEMY
    local first_enemy_intent_table = {
        {-0.50, -0.50}, -- ok
        {-0.85, -0.55}, -- ok
        nil,
        {-0.74, -0.41} -- ok
    }
    local enemy_intent_table = {
        { -- Act I
            {-0.99, -0.50}, -- ok
            {-0.50, -0.40}, -- ok
            nil,
            {-0.83, -0.41}, -- ok
            nil,
            {-0.54, -0.35}, -- ok
            {-0.74, -0.41}, -- ok
            nil,
            {-0.50, -0.40} -- ok
        },
        { -- Act II
            nil,
            nil,
            {-0.72, -0.345}, --ok
            nil,
            {-0.84, -0.445}, --ok
            nil, -- serntry knight (todo(?): maybe add two cubes in corner)
            nil,
            nil,
            nil
        },
        { -- Act III 
            {-0.845, -0.425}, --ok
            {-0.85, -0.425}, --ok
            nil,
            {-0.92, -0.235},
            nil,
            nil,
            nil
        }
    }
  
    local e_mul = {
        {0, 1, 2, 4}, -- Goobert
        {0, 1, 2, 3}, -- Imp, Shroom Horde
        {1, 3, 5, 7}, -- Driftthought
        {0, 2, 3, 5}, -- Goobert (asc 12)
        {0, 1, 3, 4}, -- Imp (asc 12)
        {1, 4, 7, 9} -- Driftthought (asc 12)
    }
    
    local hp_skipdist_r = 0.33

    local guard_shroom = {-1.01, 1.14 - (num_players - 1) * hp_skipdist_r}
    if num_players > 1 and num_players <= 4 then
        guard_shroom = {guard_shroom, {0.72, 1.50}}
    elseif num_players > 4 then
        guard_shroom = {guard_shroom, {0.72, 1.50 - 1 * hp_skipdist_r}}
    end

    local driftthought_asc12 = {-0.86, -0.425}
    if num_players < 4 then
        driftthought_asc12 = {driftthought_asc12, {-1.01, 1.14 - (num_players - 1) * hp_skipdist_r}, {0.72, 1.50 - e_mul[6][num_players] * 0.33}}
    else
        driftthought_asc12 = {driftthought_asc12, {-1.01, 1.14 - (num_players - 1) * hp_skipdist_r}, {0.72, 1.50}, {0.72, 1.50 - e_mul[6][num_players] * 0.33}}
    end

    local phantasm = {-1.01, 1.14 - (num_players - 1) * hp_skipdist_r}
    if num_players > 2 then
        phantasm = {phantasm, {0.72, 1.50}}
    end
    
    local skipdist = 0.30

    local summon_intent_table = {
        { -- Act I
            nil, 
            nil, 
            nil,
            {{-0.52, -0.41}, {-1.01, 1.14 - (num_players - 1) * skipdist}, {0.72, 1.50 - e_mul[1][num_players] * hp_skipdist_r}}, -- Elite: Goobert
            nil,
            {{-0.55, -0.40}, {-1.01, 1.14 - (num_players - 1) * skipdist}, {0.72, 1.50 - e_mul[2][num_players] * hp_skipdist_r}}, -- Elite: Imp
            nil, 
            nil,
            {{-1.01, -0.62}, {-1.01, 1.14 - (num_players - 1) * skipdist}, {0.72, 1.50 - e_mul[2][num_players] * hp_skipdist_r}}, -- Shroom Horde
            {-0.37, -0.47}, -- ok
            {-0.37, -0.47}, -- ok
            guard_shroom,
            guard_shroom,
            guard_shroom,
            {-0.37, -0.47}, -- ok
            {-0.37, -0.47}, -- ok
            {-0.37, -0.47}, -- ok
            {-0.37, -0.47}, -- ok
            {-0.37, -0.47}, -- ok
            {-0.37, -0.47}, -- ok
            {-0.37, -0.47}, -- ok
            {-0.37, -0.47}, -- ok
            {{-0.52, -0.41}, {-1.01, 1.14 - (num_players - 1) * skipdist}, {0.72, 1.50 - e_mul[4][num_players] * hp_skipdist_r}}, -- Elite: Goobert (asc 12)
            {{-0.55, -0.40}, {-1.01, 1.14 - (num_players - 1) * skipdist}, {0.72, 1.50 - e_mul[5][num_players] * hp_skipdist_r}} -- Elite: Imp (asc 12)
        },
        { -- Act II
            nil,
            nil,
            nil,
            {{-0.86, -0.425}, {-1.01, 1.14 - (num_players - 1) * skipdist}, {0.72, 1.50 - e_mul[3][num_players] * 0.33}}, -- Elite: Driftthought
            nil,
            nil,
            {-0.84, -0.445}, --ok
            nil,
            nil,
            nil, nil, nil, nil, -- Amplifier (x4)
            nil, nil, nil, nil, -- Amplifier (x4)
            driftthought_asc12
        },
        { -- Act III 
            nil,
            nil,
            nil,
            nil,
            nil,
            phantasm, -- Elite enemy
            phantasm, -- Elite enemy
            {-0.92, -0.235}
        }
    }

    local elite_intent_table = {
        { -- Act I
            {-0.48, -0.41}, --ok
            {-0.55, -0.40}, --ok
            nil, --ok
            {-0.87, -0.40}  --ok
        },
        { -- Act II
            {-0.96, -0.56}, --ok
            {-0.96, -0.61}, --ok
            {-0.62, -0.32}  --ok
        },
        { -- Act III
            {-0.89, -0.31}, --ok
            nil, --ok
            {-0.77, -0.55}  --ok
        }
    }

    local shroomhive_intent = {}
    for i = 1, 3 do
        local skip = 0.45
        shroomhive_intent[i] = {-2.385 + (i - 1) * skip, -1.942}
    end

    local boss_intent_table = {
        { -- Act I
            {-2.095, 0.45}, -- Deepcrawl Worm
            shroomhive_intent, -- Shroomhive (cobes for the tracking)
            {-2.095, 0.701} -- Webmother
        },
        { -- Act II
            {-2.095, 0.805}, -- Serpent King
            {-2.095, 0.708}, -- Gremlinator
            {-2.095, 0.928}  -- The Enlightened
        },
        { -- Act III 
            {-2.095, 0.892}, -- Clayform
            {-2.095, 0.898}, -- Doomgazer
            {-2.095, 0.534}  -- Frost Wraith
        }
    }

    -----------------------------------------------
    -- INTENT INFORMATION - ENEMY
    
    do
        local deck = getObjectFromGUID(first_enemy_deck_guid)
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            ENEMY_INTENT_ASSOCIATION[v.guid] = first_enemy_intent_table[i]
        end
    end

    for act = 1, 3 do
        local deck = getObjectFromGUID(enemy_deck_guid[act])
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            ENEMY_INTENT_ASSOCIATION[v.guid] = enemy_intent_table[act][i]
        end
    end
    
    for act = 1, 3 do
        local deck = getObjectFromGUID(summon_deck_guid[act])
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            ENEMY_INTENT_ASSOCIATION[v.guid] = summon_intent_table[act][i]
        end
    end
    
    for act = 1, 3 do
        local deck = getObjectFromGUID(elite_deck_guid[act])
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            ENEMY_INTENT_ASSOCIATION[v.guid] = elite_intent_table[act][i]
        end
    end

    for act = 1, 3 do
        local deck = getObjectFromGUID(boss_deck_guid[act])
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            ENEMY_INTENT_ASSOCIATION[v.guid] = boss_intent_table[act][i]
        end
    end

    Global.setTable("ENEMY_INTENT_ASSOCIATION", ENEMY_INTENT_ASSOCIATION)

end