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
    -----------------------------------------------
    local decks = {}

    local callback = function(o)
        o.setLock(true)
        table.insert(decks, o)
    end

    self.takeObject({
        guid = first_enemy_deck_guid,
        position = {
            self.getPosition()[1] + -5,
            self.getPosition()[2] + 3,
            self.getPosition()[3] - 3.5
        },
        rotation = rot,
        smooth = false,
        callback_function = callback
    })

    for act = 1, 3 do
        self.takeObject({
            guid = enemy_deck_guid[act],
            position = {
                self.getPosition()[1] + -2.5,
                self.getPosition()[2] + 3,
                self.getPosition()[3] + 3.5*(act - 1) - 3.5
            },
            rotation = rot,
            smooth = false,
            callback_function = callback
        })

        self.takeObject({
            guid = summon_deck_guid[act],
            position = {
                self.getPosition()[1],
                self.getPosition()[2] + 3,
                self.getPosition()[3] + 3.5*(act - 1) - 3.5
            },
            rotation = rot,
            smooth = false,
            callback_function = callback
        })

        self.takeObject({
            guid = elite_deck_guid[act],
            position = {
                self.getPosition()[1] + 2.5,
                self.getPosition()[2] + 3,
                self.getPosition()[3] + 3.5*(act - 1) - 3.5
            },
            rotation = rot,
            smooth = false,
            callback_function = callback
        })

        self.takeObject({
            guid = boss_deck_guid[act],
            position = {
                self.getPosition()[1] + 7.5,
                self.getPosition()[2] + 3,
                self.getPosition()[3] + 4.5*(act - 1) - 4.5
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
            self.getPosition()[1] + 7.5,
            self.getPosition()[2] + 3,
            self.getPosition()[3] + 4.5*(4 - 1) - 4.5
        },
        rotation = rot,
        smooth = false,
        callback_function = callback
    })

    if asc >= 11 then
        self.takeObject({
            guid = elite_deck_guid[4],
            position = {
                self.getPosition()[1] + 2.5,
                self.getPosition()[2] + 3,
                self.getPosition()[3] + 4.5*(4 - 1) - 4.5
            },
            rotation = rot,
            smooth = false,
            callback_function = callback
        })        
    end

    return decks
end
