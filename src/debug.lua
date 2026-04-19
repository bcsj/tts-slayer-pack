function debug()
    local guid = "bf2cdf"
    log(Global.getVar("ENEMY_HP_ASSOCIATION")[guid])
    log(Global.getVar("ENEMY_HP_ASSOCIATION")["615c21"])
    log(Global.getVar("SUMMON_ASSOCIATION")["adb422"])
    log(Global.getVar("SUMMON_ASSOCIATION")["dda1e7"])
    log(Global.getVar("SUMMON_ASSOCIATION")["6a9b6c"])
    log(Global.getVar("ENEMY_INTENT_ASSOCIATION")["8d5d3e"])
end

function onChat(msg, user)
    if user.admin then
        local prefix = string.sub(msg, 1, 4)
        if prefix == "emp:" then
            msg = string.sub(msg, 5)
            local colon = string.find(msg, ":")
            local cmd
            if colon == nil then
                cmd = msg
            else
                cmd = string.sub(msg, 1, colon-1)
            end

            if cmd == "unpack" then
                unpackEnemyDecks()
            elseif cmd == "pack" then
                packEnemyDecks()
            elseif cmd == "debug" then
                if DEBUG then
                    DEBUG = false
                    log("Expansion Monster Pack :: DEBUG disabled!")
                else
                    DEBUG = true
                    log("Expansion Monster Pack :: DEBUG enabled!")
                end
            elseif cmd == "insp" then
                log("inspect")
                msg = string.sub(msg, colon+1)
                local glb = false
                if string.sub(msg, 1, 7) == "Global:" then
                    log("inspect:Global")
                    glb = true
                    msg = string.sub(msg, 8)
                end

                local vname = msg
                local colon = string.find(vname, ":")

                if glb then
                    if colon == nil then
                        log(Global.getVar(vname))
                    else
                        local subscript = string.sub(vname, colon+1)
                        vname = string.sub(vname, 1, colon-1)
                        log(Global.getVar(vname)[subscript])
                    end
                else
                    if colon == nil then
                        log(_G[vname])
                    else
                        local subscript = string.sub(vname, colon+1)
                        vname = string.sub(vname, 1, colon-1)
                        log(_G[vname][subscript])
                    end
                end
            end            
        end
    end
end

function dblog(s, v)
    if not DEBUG then
        return
    end
    if type(s) == "string" then
        log("DEBUG :: " .. s)
    else
        if v == nil then
            v = "UNDEFINED"
        end
        log("DEBUG :: var " .. v .. " [ type = " .. type(s) .. " ]")
        log(s)
    end
end