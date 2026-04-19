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