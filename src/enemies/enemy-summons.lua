function setupEnemySummons()
    local SUMMON_ASSOCIATION = Global.getTable("SUMMON_ASSOCIATION")
    if SUMMON_ASSOCIATION == nil then
        SUMMON_ASSOCIATION = {}
    end
    
    local asc = getAscensionLevel()

    -----------------------------------------------
    local first_enemy_summon_table = {
        {},
        {},
        {},
        {{1, 2}}
    }
    local enemy_summon_table = {
        { -- Act I
            {},                   -- Bug Buddies (new)
            {{10, 11}, {10, 11}}, -- Dungwrecker
            {{3}},                -- Ghoul
            {{7}},                -- Glamourshroom
            {{5}},                -- Kobold (new)
            {},                   -- Mimic
            {{1, 2}, {1, 2}},     -- Mufflin
            {},                   -- Reptar
            {{8}}                 -- Tremor
        },
        { -- Act II
            {},                   -- Alchemist
            {},                   -- Artificial Fiend (new)
            {},                   -- Assassin
            {{1, 2}, {1, 2}},     -- Keeper
            {{3}, {7}},           -- Scoundrel (new)
            {{8}},                -- Sentry Knight
            {},                   -- Splinterspell
            {{5, 6}, {5, 6}},     -- Trash Colletor
            {{9}}                 -- Trickster
        },
        { -- Act III 
            {{3}},                -- Bloodroot
            {{1, 2}, {1, 2}},     -- Jellyfright
            {{4, 5}, {4, 5}},     -- Nautilorian
            {{8}},                -- Prismshade
            {},                   -- Twistbane
            {},                   -- Voidborn (new)
            {}                    -- Wrathgazer
        }
    }

    local asc = Global.getVar("ASCENSION_LEVEL")

    local goobert_summon = {4}
    local imp_summon = {6}
    local driftthought_summon = {4}

    if asc >= 12 then
        goobert_summon = {23}
        imp_summon = {24}
        driftthought_summon = {18}
    end

    local elite_summon_table = {
        { -- Act I
            {goobert_summon},   -- Goobert
            {imp_summon},       -- Imp
            {},                 -- Muncher
            {{9}}               -- Shroomboss
        },
        { -- Act II
            {},                 -- Abomination
            {},                 -- Dreadmask
            {driftthought_summon} -- Driftthought
        },
        { -- Act III
            {{6}, {7}},         -- Abyss Shriek
            {},                 -- Glimmerwing (new)
            {}                  -- Netherflame
        }
    }

    local boss_summon_table = {
        { -- Act I
            {},                   -- Deepcrawl Worm 
            {
                {12, 13, 14}, 
                {12, 13, 14}, 
                {12, 13, 14}
            },                    -- Shroomhive
            {
                {15, 16, 17, 18, 19, 20, 21, 22}
            },                    -- Webmother
        },
        { -- Act II
            {},                   -- Serpent King
            {
                {10, 11, 12, 13, 14, 15, 16, 17}
            },                    -- Gremlinator
            {}                    -- The Enlightened
        },
        { -- Act III
            {
                {13, 14, 15, 16, 17, 18, 19, 20}
            },                    -- Clayform
            {},                   -- Doomgazer
            {{9, 10, 11, 12}}     -- Frost Wraith
        }
    }

    -----------------------------------------------
    -- PAIR INFORMATION - ENEMY

    do
        local deck_summon = getObjectFromGUID(summon_deck_guid[1])
        local content_summon = deck_summon.getObjects()

        local deck_first_enemy = getObjectFromGUID(first_enemy_deck_guid)
        local content_first_enemy = deck_first_enemy.getObjects()

        for i, v in ipairs(content_first_enemy) do
            local list = {}
            for k = 1, #first_enemy_summon_table[i] do
                local sublist = {}
                for j = 1, #first_enemy_summon_table[i][k] do
                    sublist[j] = content_summon[first_enemy_summon_table[i][k][j]].guid
                end
                list[k] = sublist
            end
            if type(next(list)) == "nil" then
                -- nothing here
            else
                SUMMON_ASSOCIATION[v.guid] = {}
                SUMMON_ASSOCIATION[v.guid]["Summons"] = list
                SUMMON_ASSOCIATION[v.guid]["Boss Summons"] = {}
            end
        end
    end

    for act = 1, 3 do
        local deck_summon = getObjectFromGUID(summon_deck_guid[act])
        local content_summon = deck_summon.getObjects()

        local deck_enemy = getObjectFromGUID(enemy_deck_guid[act])
        local content_enemy = deck_enemy.getObjects()

        for i, v in ipairs(content_enemy) do
            local list = {}
            for k = 1, #enemy_summon_table[act][i] do
                local sublist = {}
                for j = 1, #enemy_summon_table[act][i][k] do
                    sublist[j] = content_summon[enemy_summon_table[act][i][k][j]].guid
                end
                list[k] = sublist
            end
            if type(next(list)) == "nil" then
                -- nothing here
            else
                SUMMON_ASSOCIATION[v.guid] = {}
                SUMMON_ASSOCIATION[v.guid]["Summons"] = list
                SUMMON_ASSOCIATION[v.guid]["Boss Summons"] = {}
            end
        end
    end
    
    -----------------------------------------------
    -- PAIR INFORMATION - ELITE
    for act = 1, 3 do
        local deck_summon = getObjectFromGUID(summon_deck_guid[act])
        local content_summon = deck_summon.getObjects()

        local deck_elite = getObjectFromGUID(elite_deck_guid[act])
        local content_elite = deck_elite.getObjects()

        for i, v in ipairs(content_elite) do
            local list = {}
            for k = 1, #elite_summon_table[act][i] do
                local sublist = {}
                for j = 1, #elite_summon_table[act][i][k] do
                    sublist[j] = content_summon[elite_summon_table[act][i][k][j]].guid
                end
                list[k] = sublist
            end
            if type(next(list)) == "nil" then
                -- nothing here
            else
                SUMMON_ASSOCIATION[v.guid] = {}
                SUMMON_ASSOCIATION[v.guid]["Summons"] = list
                SUMMON_ASSOCIATION[v.guid]["Boss Summons"] = {}
                SUMMON_ASSOCIATION[v.guid]["Flavor"] = {}
                SUMMON_ASSOCIATION[v.guid]["Flavor"]["Per Player"] = 1 + #list
                SUMMON_ASSOCIATION[v.guid]["Flavor"]["Include Elite"] = true
                SUMMON_ASSOCIATION[v.guid]["Flavor"]["Type"] = "Alternating"
            end
        end
    end

    -----------------------------------------------
    -- PAIR INFORMATION - BOSS
    for act = 1, 3 do
        local deck_summon = getObjectFromGUID(summon_deck_guid[act])
        local content_summon = deck_summon.getObjects()

        local deck_boss = getObjectFromGUID(boss_deck_guid[act])
        local content_boss = deck_boss.getObjects()

        for i, v in ipairs(content_boss) do
            local list = {}
            for k = 1, #boss_summon_table[act][i] do
                local sublist = {}
                for j = 1, #boss_summon_table[act][i][k] do
                    sublist[j] = content_summon[boss_summon_table[act][i][k][j]].guid
                end
                list[k] = sublist
            end
            if type(next(list)) == "nil" then
                -- nothing here
            else
                SUMMON_ASSOCIATION[v.guid] = {}
                SUMMON_ASSOCIATION[v.guid]["Summons"] = list
                SUMMON_ASSOCIATION[v.guid]["Boss Summons"] = {}
                SUMMON_ASSOCIATION[v.guid]["Flavor"] = {}
                -- TODO: Broken for Frost Wraith? check ...
                if #list == 1 or #list == 2 then
                    SUMMON_ASSOCIATION[v.guid]["Flavor"]["Per Player"] = 2
                elseif #list == 3 then
                    SUMMON_ASSOCIATION[v.guid]["Flavor"]["Per Player"] = 3
                end
                SUMMON_ASSOCIATION[v.guid]["Flavor"]["Type"] = "Random"
            end
        end
    end

    Global.setTable("SUMMON_ASSOCIATION", SUMMON_ASSOCIATION)
end