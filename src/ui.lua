
function applyClicked(player, clickType, xmlId)
    if withCharacterCards() then
        unpackCharacterCards()
    end
    disableUI()
end

function isToggled(xmlId)
    return self.UI.getAttribute(xmlId, "isOn") == "True"
end

function withCharacterCards()
    return isToggled("cardsToggle")
end

function withEnemies()
    return isToggled("enemiesToggle")
end

function disableUI()
    self.UI.setAttribute("applyButton", "interactable", "false")
    self.UI.setAttribute("enemiesToggle", "interactable", "false")
    self.UI.setAttribute("cardsToggle", "interactable", "false")

    local xml = self.UI.getXmlTable()
    xml[2]["children"][1]["children"][2]["value"] = "Waiting for Game Start ..."
    xml[2]["children"][1]["children"][2]["attributes"]["fontSize"] = "57"
    self.UI.setXmlTable(xml)

    self.UI.setAttribute("cardsToggle", "isOn", toggleCharacterCards)
    self.UI.setAttribute("enemiesToggle", "isOn", toggleEnemies)
end

function toggleState(player, state, xmlId)    
    self.UI.setAttribute(xmlId, "isOn", state)
end
