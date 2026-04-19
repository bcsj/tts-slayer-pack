require("tts-slayer-pack/src/debug")
require("tts-slayer-pack/src/guids")
require("tts-slayer-pack/src/util")
require("tts-slayer-pack/src/ui")
require("tts-slayer-pack/src/non-enemy-cards")

require("tts-slayer-pack/src/enemies/setup")
require("tts-slayer-pack/src/enemies/enemy-cards")
require("tts-slayer-pack/src/enemies/enemy-types")
require("tts-slayer-pack/src/enemies/enemy-intents")
require("tts-slayer-pack/src/enemies/enemy-rewards")
require("tts-slayer-pack/src/enemies/enemy-hp")
require("tts-slayer-pack/src/enemies/enemy-summons")
require("tts-slayer-pack/src/enemies/enemy-poison")

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
    if isGameStarted() then
        patch_()
        return
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
    if isGameStarted() then
        asc_check()
        unwrap()
        INITIALIZED = true
        return
    end

    msg = "Start the game like normal and press 'Setup' before the first encounter."
    rgb = {r=1, g=0, b=0}
    broadcastToAll(msg, rgb)
end

function asc_check()
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

function unwrap()
    unwrap_(true)
end

function wrap_()
    unlockAndPutFromGUID(self, first_enemy_deck_guid)

    for act = 1,3 do
        unlockAndPutFromGUID(self, enemy_deck_guid[act])
        unlockAndPutFromGUID(self, summon_deck_guid[act])
        unlockAndPutFromGUID(self, elite_deck_guid[act])
        unlockAndPutFromGUID(self, boss_deck_guid[act])
    end
end


