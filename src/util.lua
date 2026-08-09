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

function when(condition, callback)
    Wait.condition(callback, condition)
end

function whenReady(objects, callback)
    when(isDoneSpawningOrLoading(objects), callback)
end

function isDoneSpawningOrLoading(objects)
    return function()
        local check = true
        for _, obj in pairs(objects) do
            if obj.spawning or obj.loading_custom then
                check = false
                break
            end
        end
        return check
    end
end

function concatTables(out, tbl)
    for k, v in pairs(tbl) do
        out[k] = v
    end
end

-- Generates a grid of positions for cards to be placed in
-- centered around the given position. Config can specify
-- the number of columns and rows in the grid (default 4x4).
-- Index is the 0-based index of the card to be placed, 
-- counting left to right, top to bottom.
function cardGridGenerator(pos, config)
    return function(index)
        local cols = config.cols or 4
        local rows = config.rows or 4
        local y_offset = config.y_offset or 0

        local x_step = 2.5
        local z_step = 3.5
        
        local x_offset = (cols-1) / 2
        local z_offset = (rows-1) / 2

        return {
            x = pos[1] + x_step * (index % cols - x_offset),
            y = pos[2] + y_offset,
            z = pos[3] - z_step * (math.floor(index / cols) - z_offset)
        }
    end
end