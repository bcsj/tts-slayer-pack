
-- Toggle options for the UI
TOGGLE_ENEMIES = true
TOGGLE_NON_ENEMY = true

-- Callback for the apply button
function applyClicked(player, clickType, xmlId)
    if withNonEnemies() then
        unpackCharacterCards()
    end
    disableUI()
end

function disableUI()
    self.UI.setAttribute("applyButton", "interactable", "false")
    self.UI.setAttribute("enemiesToggle", "interactable", "false")
    self.UI.setAttribute("cardsToggle", "interactable", "false")

    self.UI.setValue("applyButtonText", "Waiting for Game Start ...")
    self.UI.setAttribute("applyButtonText", "fontSize", "57")
end

-- Toggles
function withEnemies()
    return TOGGLE_ENEMIES
end

function withNonEnemies()
    return TOGGLE_NON_ENEMY
end

function toggleState(player, state, xmlId)   
    if xmlId == "enemiesToggle" then
        TOGGLE_ENEMIES = state == "True"
    elseif xmlId == "cardsToggle" then
        TOGGLE_NON_ENEMY = state == "True"
    end
end

