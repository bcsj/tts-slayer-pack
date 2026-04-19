function getNumPlayers()
    return Global.call("getNumPlayers")
end

function isGameStarted()
    local game_started = Global.getVar("GAME_STARTED")
    if game_started == nil then
        return false
    else
        return game_started
    end
end

function getAscensionLevel()
    local ascension_level = Global.getVar("ASCENSION_LEVEL")
    if ascension_level == nil then
        return 0
    else
        return ascension_level
    end
end

function unlockAndPutFromGUID(container, guid)
    local obj = getObjectFromGUID(guid)
    obj.setLock(false)
    container.putObject(obj)
end

function isInGame(character)
    local player_to_character = Global.getTable("PLAYER_TO_CHARACTER")
    for _, v in pairs(player_to_character) do
        if v == character then
            return true
        end
    end
    return false
end