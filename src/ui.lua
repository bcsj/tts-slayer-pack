
function applyClicked(player, clickType, xmlId)
    local withCards = isToggled("cardsToggle")
    if withCards then
        unpackCharacterCards()
    end
    disableUI()
end

function isToggled(xmlId)
    return self.UI.getAttribute(xmlId, "isOn") == "True"
end

function disableUI()
    self.UI.setAttribute("applyButton", "interactable", "false")
    self.UI.setAttribute("enemiesToggle", "interactable", "false")
    self.UI.setAttribute("cardsToggle", "interactable", "false")
    
    local xml = self.UI.getXmlTable()
    xml[2]["children"][1]["children"][2]["value"] = "Waiting for Game Start ..."
    xml[2]["children"][1]["children"][2]["attributes"]["fontSize"] = "57"
    self.UI.setXmlTable(xml)
end
