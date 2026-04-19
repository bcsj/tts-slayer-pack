require("tts-slayer-pack/src/debug")
require("tts-slayer-pack/src/guids")
require("tts-slayer-pack/src/ui")
require("tts-slayer-pack/src/non-enemy-cards")

INITIALIZED = false

function onSave()
    local state = {
        initialized = INITIALIZED
    }
    return JSON.encode(state)
end

function onLoad(saveState)
    local state = JSON.decode(saveState)
    if state ~= nil then
        INITIALIZED = state["initialized"]
    end

    if INITIALIZED then
        disableUI()
        return
    end

    -- Debug setting
    DEBUG = false
    DEBUG_FORCE_NEW_BOSS = false -- forces a new boss for act 1
    DEBUG_FORCE_BOSS_PICK = nil  -- selects which new boss we spawn for act 1
    
    --[[ ------------------------------------------------------------------------------
    
    We check if the game has already started, if it haw then we immediately patch. This
    supports the sequence where players load the StS mod, select their characters, then
    start the game, and after that do the 'additive load' of this mod.

    -------------------------------------------------------------------------------- ]]
    local GameStarted = Global.getVar("GAME_STARTED")
    if GameStarted ~= nil then
        if GameStarted then
            patch_()
            return
        end
    end

    --[[ ------------------------------------------------------------------------------

    We track the position of the boot meeple to know when to invoke the setup function.
    When the boot meeple moves to the starting spot on the map we know that we are late
    enough in setup to be able to safely unpack and that we can patch all the relevant
    data tables with the information for the new monsters.

    -------------------------------------------------------------------------------- ]]
    local boot_meeple = getObjectFromGUID("d4e0e6")
    if boot_meeple ~= nil then
        Wait.condition(patch_, function()   
            local pos = boot_meeple.getPosition()
            return (-1.35 < pos[1] and pos[1] < -1.33) and 
                (1.05 < pos[2] and pos[2] < 1.07) and
                (0.50 < pos[3] and pos[3] < 0.52)
        end)
    end
    -----------------------------------------------------------------------------------
end


function patch_()
    if withEnemies() then
        patch()
    end
    self.setPositionSmooth(Vector(-17, 7, 31), false, false)
end

function patch()
    local check = Global.getVar("GAME_STARTED")
    if check ~= nil then
        if check then
            asc_check()
            unpack()
            INITIALIZED = true
            return
        end
    end
    msg = "Start the game like normal and press 'Setup' before the first encounter."
    rgb = {r=1, g=0, b=0}
    broadcastToAll(msg, rgb)
end

function asc_check()
    local asc = Global.getVar("ASCENSION_LEVEL")
    if asc >= 1 then
        sts_elite_deck_guid = sts_asc_guid[1]
    end
    if asc >= 7 then
        sts_enemy_deck_guid = sts_asc_guid[2]
    end
    if asc >= 10 then
        sts_boss_deck_guid = sts_asc_guid[4]
        boss_deck_guid[1] = boss_asc_deck_guid[1]
        boss_deck_guid[2] = boss_asc_deck_guid[2]
        boss_deck_guid[3] = boss_asc_deck_guid[3]
    end
    if asc >= 11 then
        boss_deck_guid[4] = boss_asc_deck_guid[4]
    end
    if asc >= 12 then
        sts_elite_deck_guid = sts_asc_guid[3]
        elite_deck_guid[1] = elite_asc_deck_guid[1]
        elite_deck_guid[2] = elite_asc_deck_guid[2]
        elite_deck_guid[3] = elite_asc_deck_guid[3]
    end
end

function unpack()
    unpack_(true)
end

function pack_()
    local deck = getObjectFromGUID(first_enemy_deck_guid)
    deck.setLock(false)
    self.putObject(deck)

    for act = 1,3 do
        deck = getObjectFromGUID(enemy_deck_guid[act])
        deck.setLock(false)
        self.putObject(deck)
        deck = getObjectFromGUID(summon_deck_guid[act])
        deck.setLock(false)
        self.putObject(deck)
        deck = getObjectFromGUID(elite_deck_guid[act])
        deck.setLock(false)
        self.putObject(deck)
        deck = getObjectFromGUID(boss_deck_guid[act])
        deck.setLock(false)
        self.putObject(deck)
    end
end

function unpack_(do_setup)

    -----------------------------------------------
    local deck_enemy = {}
    local deck_summon = {}
    local deck_elite = {}
    local deck_boss = {}
    local deck_first = nil

    deck_first = self.takeObject({
        guid = first_enemy_deck_guid,
        position = {
            self.getPosition()[1] + -5,
            self.getPosition()[2] + 3,
            self.getPosition()[3] - 3.5
        },
        rotation = {0, 180, 180},
        smooth = false
    })
    deck_first.setLock(true)

    for act = 1, 3 do
        deck_enemy[act] = self.takeObject({
            guid = enemy_deck_guid[act],
            position = {
                self.getPosition()[1] + -2.5,
                self.getPosition()[2] + 3,
                self.getPosition()[3] + 3.5*(act - 1) - 3.5
            },
            rotation = {0, 180, 180},
            smooth = false
        })
        deck_enemy[act].setLock(true)

        deck_summon[act] = self.takeObject({
            guid = summon_deck_guid[act],
            position = {
                self.getPosition()[1],
                self.getPosition()[2] + 3,
                self.getPosition()[3] + 3.5*(act - 1) - 3.5
            },
            rotation = {0, 180, 180},
            smooth = false
        })
        deck_summon[act].setLock(true)

        deck_elite[act] = self.takeObject({
            guid = elite_deck_guid[act],
            position = {
                self.getPosition()[1] + 2.5,
                self.getPosition()[2] + 3,
                self.getPosition()[3] + 3.5*(act - 1) - 3.5
            },
            rotation = {0, 180, 180},
            smooth = false
        })
        deck_elite[act].setLock(true)

        deck_boss[act] = self.takeObject({
            guid = boss_deck_guid[act],
            position = {
                self.getPosition()[1] + 7.5,
                self.getPosition()[2] + 3,
                self.getPosition()[3] + 4.5*(act - 1) - 4.5
            },
            rotation = {0, 180, 180},
            smooth = false
        })
        deck_boss[act].setLock(true)
    end
    
    -- Act IV
    deck_boss[4] = self.takeObject({
        guid = boss_deck_guid[4],
        position = {
            self.getPosition()[1] + 7.5,
            self.getPosition()[2] + 3,
            self.getPosition()[3] + 4.5*(4 - 1) - 4.5
        },
        rotation = {0, 180, 180},
        smooth = false
    })
    deck_boss[4].setLock(true)

    local asc = Global.getVar("ASCENSION_LEVEL")
    if asc >= 11 then
        deck_elite[4] = self.takeObject({
            guid = elite_deck_guid[4],
            position = {
                self.getPosition()[1] + 2.5,
                self.getPosition()[2] + 3,
                self.getPosition()[3] + 4.5*(4 - 1) - 4.5
            },
            rotation = {0, 180, 180},
            smooth = false
        })
        deck_elite[4].setLock(true)
    end

    if do_setup then
        Wait.condition(setup, function()
            check = (not deck_first.spawning and not deck_first.loading_custom)
                and (not deck_enemy[1].spawning and not deck_enemy[1].loading_custom) 
                and (not deck_enemy[2].spawning and not deck_enemy[2].loading_custom)
                and (not deck_enemy[3].spawning and not deck_enemy[3].loading_custom)
                and (not deck_summon[1].spawning and not deck_summon[1].loading_custom) 
                and (not deck_summon[2].spawning and not deck_summon[2].loading_custom)
                and (not deck_summon[3].spawning and not deck_summon[3].loading_custom)
                and (not deck_elite[1].spawning and not deck_elite[1].loading_custom) 
                and (not deck_elite[2].spawning and not deck_elite[2].loading_custom)
                and (not deck_elite[3].spawning and not deck_elite[3].loading_custom)
                and (not deck_boss[1].spawning and not deck_boss[1].loading_custom) 
                and (not deck_boss[2].spawning and not deck_boss[2].loading_custom)
                and (not deck_boss[3].spawning and not deck_boss[3].loading_custom)
                and (not deck_boss[4].spawning and not deck_boss[4].loading_custom)
            return check
        end)
    end
end

function setup()
    
    
    ---------------------------------------------------------------
    local PLAYER_TO_CHARACTER = Global.getTable("PLAYER_TO_CHARACTER")
    -- Get out some poison tokens if Silent isn't already in the game
    local isSilent = false
    for k, v in pairs(PLAYER_TO_CHARACTER) do
        if v == "Silent" then
            isSilent = true
        end
    end

    if not isSilent then
        local silent_bag = getObjectFromGUID(sts_silent_bag_guid)
        local xpos = {17.25, 17.33, 17.41}
        local zpos = {3.24, 3.16, 3.24}
        for i = 1, 3 do
            silent_bag.takeObject({
                guid = sts_silent_poison_guids[i],
                position = {xpos[i], 1.05 + (i-1) * 0.15, zpos[i]},
                rotation = {0, 180, 0}
            })
        end
    end

    -----------------------------------------------
    local SUMMON_ASSOCIATION = Global.getTable("SUMMON_ASSOCIATION")
    if SUMMON_ASSOCIATION == nil then
        SUMMON_ASSOCIATION = {}
    end
    local ENEMY_HP_ASSOCIATION = Global.getTable("ENEMY_HP_ASSOCIATION")
    if ENEMY_HP_ASSOCIATION == nil then
        ENEMY_HP_ASSOCIATION = {}
    end
    local ENEMY_REWARD_ASSOCIATION = Global.getTable("ENEMY_REWARD_ASSOCIATION")    
    if ENEMY_REWARD_ASSOCIATION == nil then
        ENEMY_REWARD_ASSOCIATION = {}
    end
    local ENEMY_INTENT_ASSOCIATION = Global.getTable("ENEMY_INTENT_ASSOCIATION")    
    if ENEMY_INTENT_ASSOCIATION == nil then
        ENEMY_INTENT_ASSOCIATION = {}
    end
    
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
    local num_players = Global.call("getNumPlayers")
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


    -----------------------------------------------
    -- PUT CARDS
    
    local sts_first_enemy_deck = getObjectFromGUID(sts_first_enemy_deck_guid)
    local first_enemy_deck = getObjectFromGUID(first_enemy_deck_guid)
    first_enemy_deck.setLock(false)
    sts_first_enemy_deck.putObject(first_enemy_deck)
    sts_first_enemy_deck.shuffle()

    local sts_bag = {
        getObjectFromGUID(sts_bags[1]),
        getObjectFromGUID(sts_bags[2]),
        getObjectFromGUID(sts_bags[3]),
        getObjectFromGUID(sts_bags[4])
    }

    local sts_enemy_deck = {}
    local enemy_deck = {}
    local sts_summon_deck = {}
    local summon_deck = {}
    local sts_elite_deck = {}
    local elite_deck = {}
    local sts_boss_deck = {}
    local boss_deck = {}

    -- Enemy cards

    sts_enemy_deck[1] = getObjectFromGUID(sts_enemy_deck_guid[1])
    enemy_deck[1] = getObjectFromGUID(enemy_deck_guid[1])
    enemy_deck[1].setLock(false)
    dblog(enemy_deck, "enemy_deck")
    sts_enemy_deck[1].putObject(enemy_deck[1])
    sts_enemy_deck[1].shuffle()

    for act = 2, 3 do
        enemy_deck[act] = getObjectFromGUID(enemy_deck_guid[act])
        sts_enemy_deck[act] = sts_bag[act].takeObject({
            guid = sts_enemy_deck_guid[act],
            position = {
                sts_bag[act].getPosition()[1],
                sts_bag[act].getPosition()[2] + 4,
                sts_bag[act].getPosition()[3]
            },
            rotation = {0, 180, 180},
            smooth = false,
            callback_function = function (o)
                enemy_deck[act].setLock(false)
                dblog("callback act = " .. act)
                dblog(enemy_deck, "enemy_deck")
                o.putObject(enemy_deck[act])
                sts_bag[act].putObject(sts_enemy_deck[act])
            end
        })
    end

    -- Summon cards

    sts_summon_deck[1] = getObjectFromGUID(sts_summon_deck_guid[1])
    summon_deck[1] = getObjectFromGUID(summon_deck_guid[1])
    summon_deck[1].setLock(false)
    dblog(summon_deck, "summon_deck")
    sts_summon_deck[1].putObject(summon_deck[1])
    sts_summon_deck[1].shuffle()

    for act = 2, 3 do
        summon_deck[act] = getObjectFromGUID(summon_deck_guid[act])
        sts_summon_deck[act] = sts_bag[act].takeObject({
            guid = sts_summon_deck_guid[act],
            position = {
                sts_bag[act].getPosition()[1],
                sts_bag[act].getPosition()[2] + 8,
                sts_bag[act].getPosition()[3]
            },
            rotation = {0, 180, 180},
            smooth = false,
            callback_function = function (o) 
                summon_deck[act].setLock(false)
                dblog("callback act = " .. act)
                dblog(summon_deck, "summon_deck")
                o.putObject(summon_deck[act])
                sts_bag[act].putObject(sts_summon_deck[act])
            end
        })
    end
    
    -- Elite cards

    sts_elite_deck[1] = getObjectFromGUID(sts_elite_deck_guid[1])
    elite_deck[1] = getObjectFromGUID(elite_deck_guid[1])
    elite_deck[1].setLock(false)
    dblog(elite_deck, "elite_deck")
    sts_elite_deck[1].putObject(elite_deck[1])
    sts_elite_deck[1].shuffle()
    
    for act = 2, 3 do
        elite_deck[act] = getObjectFromGUID(elite_deck_guid[act])
        sts_elite_deck[act] = sts_bag[act].takeObject({
            guid = sts_elite_deck_guid[act],
            position = {
                sts_bag[act].getPosition()[1],
                sts_bag[act].getPosition()[2] + 12,
                sts_bag[act].getPosition()[3]
            },
            rotation = {0, 180, 180},
            smooth = false,
            callback_function = function (o) 
                elite_deck[act].setLock(false)
                dblog("callback act = " .. act)
                dblog(elite_deck, "elite_deck")
                o.putObject(elite_deck[act])
                sts_bag[act].putObject(sts_elite_deck[act])
            end
        })
    end

    -- Boss

    -- Flip a coin to determine if the boss will be regular or custom
    local active_boss_card_guid = Global.getVar("ACTIVE_BOSS_CARDS")[1]

    boss_deck[1] = getObjectFromGUID(boss_deck_guid[1])
    
    if DEBUG_FORCE_NEW_BOSS or math.random(1, 2) == 1 then
        -- In this case we pick a new boss
        local active_boss_card = getObjectFromGUID(active_boss_card_guid)
        local pos = active_boss_card.getPosition()
        active_boss_card.setPosition({
            pos[1],
            pos[2] + 2,
            pos[3]
        })
        active_boss_card.setLock(true)

        local boss_card
        if DEBUG_FORCE_BOSS_PICK then
            boss_card = boss_deck[1].takeObject({
                position = pos,
                rotation = {0, 180, 180},
                smooth = false,
                index = DEBUG_FORCE_BOSS_PICK
            })
        else
            boss_deck[1].shuffle()
            boss_card = boss_deck[1].takeObject({
                position = pos,
                rotation = {0, 180, 180},
                smooth = false
            })
        end 

        sts_boss_deck[1] = sts_bag[1].takeObject({
            guid = sts_boss_deck_guid[1],
            position = {
                sts_bag[1].getPosition()[1],
                sts_bag[1].getPosition()[2] + 16,
                sts_bag[1].getPosition()[3]
            },
            rotation = {0, 180, 180},
            smooth = false,
            callback_function = function (o)
                active_boss_card.setLock(false)
                o.putObject(active_boss_card)

                boss_deck[1].setLock(false)
                dblog("callback act = " .. 1)
                dblog(boss_deck, "boss_deck")
                o.putObject(boss_deck[1])
                sts_bag[1].putObject(sts_boss_deck[1])
            end
        })

        Global.setTable("ACTIVE_BOSS_CARDS", {boss_card.guid})
    else
        -- We just put the boss cards into the bag
        sts_boss_deck[1] = sts_bag[1].takeObject({
            guid = sts_boss_deck_guid[1],
            position = {
                sts_bag[1].getPosition()[1],
                sts_bag[1].getPosition()[2] + 16,
                sts_bag[1].getPosition()[3]
            },
            rotation = {0, 180, 180},
            smooth = false,
            callback_function = function (o)
                boss_deck[1].setLock(false)
                dblog("callback act = " .. 1)
                dblog(boss_deck, "boss_deck")
                o.putObject(boss_deck[1])
                o.shuffle()
                sts_bag[1].putObject(sts_boss_deck[1])
            end
        })
    end

    for act = 2, 3 do
        boss_deck[act] = getObjectFromGUID(boss_deck_guid[act])
        sts_boss_deck[act] = sts_bag[act].takeObject({
            guid = sts_boss_deck_guid[act],
            position = {
                sts_bag[act].getPosition()[1],
                sts_bag[act].getPosition()[2] + 16,
                sts_bag[act].getPosition()[3]
            },
            rotation = {0, 180, 180},
            smooth = false,
            callback_function = function (o) 
                boss_deck[act].setLock(false)
                dblog("callback act = " .. act)
                dblog(boss_deck, "boss_deck")
                o.putObject(boss_deck[act])
                o.shuffle()
                sts_bag[act].putObject(sts_boss_deck[act])
            end
        })
    end

    -- Act 4 boss and elites

    boss_deck[4] = getObjectFromGUID(boss_deck_guid[4])
    if math.random(1, 2) == 1 then
        local ACT_COMPONENTS = Global.getTable("ACT_COMPONENTS")
        ACT_COMPONENTS[4]["BossDeck"] = boss_deck[4].guid
        Global.setTable("ACT_COMPONENTS", ACT_COMPONENTS)
    end 
    boss_deck[4].setLock(false)
    sts_bag[4].putObject(boss_deck[4])

    -- Ascension 11
    local asc = Global.getVar("ASCENSION_LEVEL")
    if asc >= 11 then
        elite_deck[4] = getObjectFromGUID(elite_deck_guid[4])
        log('==============================')
        log(sts_elite_deck_guid[4])
        log('==============================')
        sts_elite_deck[4] = sts_bag[4].takeObject({
            guid = sts_elite_deck_guid[4],
            position = {
                sts_bag[4].getPosition()[1],
                sts_bag[4].getPosition()[2] + 12,
                sts_bag[4].getPosition()[3]
            },
            rotation = {0, 180, 180},
            smooth = false,
            callback_function = function (o) 
                elite_deck[4].setLock(false)
                o.putObject(elite_deck[4])
                sts_bag[4].putObject(sts_elite_deck[4])
            end
        })

    end

end
