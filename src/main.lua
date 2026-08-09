require("tts-slayer-pack/src/debug")

require("tts-slayer-pack/src/guids")
require("tts-slayer-pack/src/util")
require("tts-slayer-pack/src/ui/ui")

require("tts-slayer-pack/src/non-enemies/imports")
require("tts-slayer-pack/src/enemies/imports")

require("tts-slayer-pack/src/detect-mod-version")

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
    -- if isGameStarted() then
    --     patch_()
    --     return
    -- end

    --[[ ------------------------------------------------------------------------------

    We track the position of the boot meeple to know when to invoke the setup function.
    When the boot meeple moves to the starting spot on the map we know that we are late
    enough in setup to be able to safely unpack and that we can patch all the relevant
    data tables with the information for the new monsters.

    -------------------------------------------------------------------------------- ]]
    local meeple
    if isCoreGameMod() then
        -- boot_meeple    
        meeple = getObjectFromGUID("d4e0e6")
    elseif isDownfallGameMod() then
        -- hat_meeple
        meeple = getObjectFromGUID("668988")
    end
    if meeple ~= nil then
        when(function() 
            return isMeepleInStartingPosition(meeple)
        end, patch)
    end
    
    -----------------------------------------------------------------------------------
end

function patch()
    if withEnemies() and isGameStarted() then
        -- Update guids based on ascension level
        ascensionPatch()
        -- We unpack the decks, then run setup when ready
        local decks = unpackEnemyDecks()
        whenReady(decks, setupEnemies)
        -- Set initialized to true in case of saves
        INITIALIZED = true
    end

    putAwayBox()    
end

function putAwayBox()
    self.setPositionSmooth(Vector(-17, 7, 31), false, false)
    self.setLock(false)
end

function isMeepleInStartingPosition(meeple)
    if meeple == nil then
        return false
    end
    local pos = meeple.getPosition()
    return (-1.35 < pos[1] and pos[1] < -1.33) and 
        (1.05 < pos[2] and pos[2] < 1.50) and
        (0.50 < pos[3] and pos[3] < 0.52)
end

