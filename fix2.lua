-- made by peke
local olddebug; olddebug = hookfunction(debug.info, function(...) 
    if (...) then
        local Arguments = {...}

        if Arguments and #Arguments >= 2 and Arguments[1] == 2 and Arguments[2] == "f" then
            return coroutine.yield(coroutine.running()) -- Pause when a crash attempt is detected
        end
    end

    return olddebug(...)
end)

local oldsm; oldsm = hookfunction(setmetatable, function(...) 
    local Arguments = {...}
    if getcallingscript() and tostring(getcallingscript()) == "Client" and not getcallingscript().IsDescendantOf(getcallingscript(), game) and #Arguments == 2 then
        if Arguments[1]["Pcall"] and Arguments[2]["__index"] then -- Means we are within the right table
           Arguments[2]["__index"] = function(self, ind)
                if ind == "Kill" then
                    return function() end
                end
            end
        end

        return oldsm(table.unpack(Arguments))
    end

    return oldsm(...)
end)
