function setupEnemyHP()
    local ENEMY_HP_ASSOCIATION = Global.getTable("ENEMY_HP_ASSOCIATION")
    if ENEMY_HP_ASSOCIATION == nil then
        ENEMY_HP_ASSOCIATION = {}
    end

    local num_players = getNumPlayers()
    local asc = getAscensionLevel()

    -----------------------------------------------
    local first_enemy_hp_table = {9, 8, 9, 8} 
    -- Dungwrecker, Glamourshroom, Kobold, Mufflin
    
    local enemy_hp_table = {
        { -- Act I
            13, 8, 6, 7, 8, 12, 8, 13, 9
            -- 1) Bug Buddies, 2) Dungwrecker, 3) Ghoul, 4) Glamourshroom
            -- 5) Kobold, 6) Mimic, 7) Mufflin, 8) Reptar, 9) Tremor
        },
        { -- Act II
            19, 16, 19, 13, 12, 17, 20, 15, 14
            -- 1) Alchemist, 2) Artificial Fiend, 3) Assassin, 4) Keeper,
            -- 5) Scoundrel, 6) Sentry Knight, 7) Splinterspell,
            -- 8) Trash Collector, 9) Trickster
        },
        { -- Act III 
            23, 18, 18, 16, 25, 35, 25
            -- 1) Bloodroot, 2) Jellyfright, 3) Nautilorian,
            -- 4) Prismshade, 5) Twistbane, 6) Voidborn,
            -- 7) Wrathgazer
        }
    }

    --[[ ------------------------------------------------------------------------------
    ===  HP trick  ===
    -----------------------------------------------------------------------------------

    For summons with HP that depends on the number of players,
    we set the HP value based on "the last digit in their HP" +1 because
    cards with scaling HP like that count from 0 instead.

    The HP cubes to track other digits are set using the mechanics which
    are also used to set the cube marking the action the enemy would take,
    this part is setup using the INTENT cubes.

    -------------------------------------------------------------------------------- ]]
    local summon_hp_table = {
        { -- Act I
            4, 4, 6,            -- Battleshroom, Battleshroom, Ghoul
            -- HP trick to set the value correctly, 
            -- because single-digits count from 0
            {4, 7, 10, 3},      -- Goobert (summon)
            6,                  -- Grollock
            -- HP trick
            {3, 5, 7, 9},       -- Imp (summon) 
            6, 5,               -- Pestshroom, Shield Gremlin
            -- HP trick
            {3, 5, 7, 9},       -- Shroom Horde
            4, 4,               -- Webweaver, Webweaver
            -- HP trick
            {6, 1, 6, 1},       -- Guardshroom
            {6, 1, 6, 1},       -- Guardshroom
            {6, 1, 6, 1},       -- Guardshroom
            4, 4, 4, 4,         -- Webweaver, Webweaver, Webweaver, Webweaver
            4, 4, 4, 4,         -- Webweaver, Webweaver, Webweaver, Webweaver
            -- HP trick
            {6, 2, 9, 7},       -- Goobert (asc 12 summon)
            -- HP trick
            {4, 8, 3, 9}        -- Imp (asc 12 summon) 
        },
        { -- Act II
            6, 6, 3,            -- Bugbeast, Bugbeast, Captive Traveler
            -- HP trick
            {3, 5, 7, 9},       -- Diftthought (summon)
            6, 6, 12, 7, 14,    -- Junkbot, Junkbot, Scoundrel (summon),
                                -- Sentry C, Trickster
            -- HP trick to set value to 10, since aplifier starts count at 2
            9, 9, 9, 9,        
            9, 9, 9, 9,         -- Amplifier x8
            -- HP trick
            {7, 5, 5, 7},       -- Diftthought (asc 12 summon)
        },
        { -- Act III
            7, 7, 8, 7, 7,      -- Claymate, Claymate, Creeper
                                -- Icelume, Icelume
            -- HP trick
            {5, 9, 3, 7},       -- Phantasm
            {5, 9, 3, 7},       -- Phantasm
            17,                 -- Prismshade
            10, 10, 10, 10,     -- Flamelume x4
            7, 7, 7, 7,
            7, 7, 7, 7          -- Claymate x8
        }
    }

    -- Act I
    local goobert_hp = {13, 26, 39, 52}
    local imp_hp = {12, 24, 36, 48}
    local muncher_hp = {21, 43, 66, 90}
    local shroomboss_hp = {14, 31, 49, 68}
    -- Act II
    local abomination_hp = {44, 88, 132, 176}
    local dreadmask_hp = {42, 84, 126, 168}
    local driftthought_hp = {22, 44, 66, 88}
    -- Act III
    local abyss_shriek_hp = {36, 72, 108, 144}
    local glimmerwing_hp = {95, 190, 285, 380}
    local netherflame_hp = {66, 132, 198, 264}

    if asc >= 12 then -- update for ascension variants
        -- Act I
        goobert_hp = {15, 31, 48, 66}
        imp_hp = {13, 27, 42, 58}
        muncher_hp = {24, 51, 81, 114}
        shroomboss_hp = {17, 37, 60, 86}
        -- Act II
        abomination_hp = {50, 104, 162, 224}
        dreadmask_hp = {48, 100, 156, 216}
        driftthought_hp = {26, 54, 84, 116}
        -- Act III
        abyss_shriek_hp = {40, 84, 132, 184}
        glimmerwing_hp = {103, 214, 333, 460}
        netherflame_hp = {72, 150, 234, 324}
    end

    local elite_hp_table = {
        { -- Act I
            goobert_hp,
            imp_hp,
            muncher_hp,
            shroomboss_hp
        },
        { -- Act II
            abomination_hp,
            dreadmask_hp,
            driftthought_hp
        },
        { -- Act III
            abyss_shriek_hp,
            glimmerwing_hp,
            netherflame_hp
        }
    }

    -- Act I
    local deepcrawl_worm_hp = {45, 90, 135, 180}
    local shroomhive_hp = {30, 63, 99, 138}
    local webmother_hp = {37, 74, 111, 148}
    -- Act II
    local serpent_king_hp = {77, 154, 231, 308}
    local gremlinator_hp = {70, 140, 210, 280}
    local the_enlightened_hp = {80, 160, 240, 320}
    -- Act III
    local clayform_hp = {100, 200, 300, 400}
    local doomgazer_hp = {110, 220, 330, 440}
    local frost_wraith_hp = {95, 190, 285, 380}

    if asc >= 10 then -- update for ascension variants
        deepcrawl_worm_hp = {50, 100, 150, 200}
        shroomhive_hp = {34, 71, 111, 154}
        webmother_hp = {41, 82, 123, 164}
        -- Act II
        serpent_king_hp = {86, 172, 258, 344}
        gremlinator_hp = {77, 154, 231, 308}
        the_enlightened_hp = {86, 172, 258, 344}
        -- Act III
        clayform_hp = {110, 220, 330, 440}
        doomgazer_hp = {120, 240, 360, 480}
        frost_wraith_hp = {100, 200, 300, 400}
    end

    local boss_hp_table = {
        { -- Act I
            deepcrawl_worm_hp, -- Deepcrawl Worm
            shroomhive_hp, -- Shroomhive
            webmother_hp  -- Webmother
        },
        { -- Act II
            serpent_king_hp, -- Serpent King
            gremlinator_hp, -- Gremlinator
            the_enlightened_hp  -- The Enlightened
        },
        { -- Act III
            clayform_hp, -- Clayform
            doomgazer_hp, -- Doomgazer
            frost_wraith_hp  -- Frost Wraith
        }
    }

    -----------------------------------------------
    -- HP INFORMATION - ENEMY
    
    do
        local deck = getObjectFromGUID(first_enemy_deck_guid)
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            ENEMY_HP_ASSOCIATION[v.guid] = first_enemy_hp_table[i]
        end
    end

    for act = 1, 3 do
        local deck = getObjectFromGUID(enemy_deck_guid[act])
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            ENEMY_HP_ASSOCIATION[v.guid] = enemy_hp_table[act][i]
        end
    end

    for act = 1, 3 do
        local deck = getObjectFromGUID(summon_deck_guid[act])
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            local hp = summon_hp_table[act][i]
            if type(hp) == "table" then
                ENEMY_HP_ASSOCIATION[v.guid] = hp[num_players]
            else
                ENEMY_HP_ASSOCIATION[v.guid] = hp
            end
        end
    end
    
    for act = 1, 3 do
        local deck = getObjectFromGUID(elite_deck_guid[act])
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            local hp = elite_hp_table[act][i]
            if type(hp) == "table" then
                ENEMY_HP_ASSOCIATION[v.guid] = hp[num_players]
            else
                ENEMY_HP_ASSOCIATION[v.guid] = hp
            end
        end
    end

    for act = 1, 3 do
        local deck = getObjectFromGUID(boss_deck_guid[act])
        local content = deck.getObjects()

        for i, v in ipairs(content) do
            local hp = boss_hp_table[act][i]
            if type(hp) == "table" then
                ENEMY_HP_ASSOCIATION[v.guid] = hp[num_players]
            else
                ENEMY_HP_ASSOCIATION[v.guid] = hp
            end
        end
    end

    Global.setTable("ENEMY_HP_ASSOCIATION", ENEMY_HP_ASSOCIATION)

end