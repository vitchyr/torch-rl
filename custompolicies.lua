require 'constants'

local M = {}

--[[
-- A simple policy that always does the same thing based on the player's sum:
--  Hit if their sum is greater than some threshold `t`.
--]]
function M.get_threshold_policy(t)
    return function (s)
        local dealerSum, playerSum = table.unpack(s)
        if playerSum < t then
            return HIT
        else
            return STICK
        end
    end
end

function M.always_hit(s)
    return HIT
end

function M.always_stick(s)
    return STICK
end

return M
