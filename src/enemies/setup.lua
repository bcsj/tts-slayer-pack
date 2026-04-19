function setupEnemies()
    ---------------------------------------------------------------
    -- One of the enemies uses Silent's poison tokens
    -- so if Silent is not in the game, we bring them
    -- out for convenience.
    if not isInGame("Silent") then
        getPoisonTokens()
    end

    -----------------------------------------------
    setupEnemySummons()
    setupEnemyHP()
    setupEnemyRewards()
    setupEnemyIntents()
    setupEnemyTypes()

    -----------------------------------------------
    mergeEnemyDecks()
end

function ascensionPatch()
    local asc = getAscensionLevel()
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

function packEnemyDecks()
    unlockAndPutFromGUID(self, first_enemy_deck_guid)

    for act = 1,3 do
        unlockAndPutFromGUID(self, enemy_deck_guid[act])
        unlockAndPutFromGUID(self, summon_deck_guid[act])
        unlockAndPutFromGUID(self, elite_deck_guid[act])
        unlockAndPutFromGUID(self, boss_deck_guid[act])
    end
    unlockAndPutFromGUID(self, boss_deck_guid[4])
end

function unpackEnemyDecks()
    local asc = getAscensionLevel()
    local rot = {0, 180, 180}
    local pos = self.getPosition()
    -----------------------------------------------
    local decks = {}

    local callback = function(o)
        o.setLock(true)
        table.insert(decks, o)
    end

    self.takeObject({
        guid = first_enemy_deck_guid,
        position = {
            pos[1] + -5,
            pos[2] + 3,
            pos[3] - 3.5
        },
        rotation = rot,
        smooth = false,
        callback_function = callback
    })

    for act = 1, 3 do
        self.takeObject({
            guid = enemy_deck_guid[act],
            position = {
                pos[1] + -2.5,
                pos[2] + 3,
                pos[3] + 3.5*(act - 1) - 3.5
            },
            rotation = rot,
            smooth = false,
            callback_function = callback
        })

        self.takeObject({
            guid = summon_deck_guid[act],
            position = {
                pos[1],
                pos[2] + 3,
                pos[3] + 3.5*(act - 1) - 3.5
            },
            rotation = rot,
            smooth = false,
            callback_function = callback
        })

        self.takeObject({
            guid = elite_deck_guid[act],
            position = {
                pos[1] + 2.5,
                pos[2] + 3,
                pos[3] + 3.5*(act - 1) - 3.5
            },
            rotation = rot,
            smooth = false,
            callback_function = callback
        })

        self.takeObject({
            guid = boss_deck_guid[act],
            position = {
                pos[1] + 7.5,
                pos[2] + 3,
                pos[3] + 4.5*(act - 1) - 4.5
            },
            rotation = rot,
            smooth = false,
            callback_function = callback
        })
    end
    
    -- Act IV
    self.takeObject({
        guid = boss_deck_guid[4],
        position = {
            pos[1] + 7.5,
            pos[2] + 3,
            pos[3] + 4.5*(4 - 1) - 4.5
        },
        rotation = rot,
        smooth = false,
        callback_function = callback
    })

    if asc >= 11 then
        self.takeObject({
            guid = elite_deck_guid[4],
            position = {
                pos[1] + 2.5,
                pos[2] + 3,
                pos[3] + 4.5*(4 - 1) - 4.5
            },
            rotation = rot,
            smooth = false,
            callback_function = callback
        })        
    end

    return decks
end
