function mergeEnemyDecks()

    -- First enemy deck (Act I pre-encounter)

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

    -- Boss cards

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
