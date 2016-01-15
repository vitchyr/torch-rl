require 'constants'
require 'Policy'

do
    --[[
    -- A simple policy that always does the same thing based on the player's sum:
    --  Hit if their sum is greater than some threshold `t`.
    --]]
    local ThresholdPolicy, parent = torch.class('ThresholdPolicy', 'Policy')

    function ThresholdPolicy:__init(threshold)
        parent.__init(self)
        self.threshold = threshold
    end

    function ThresholdPolicy:get_action(s)
        local _, player_sum = table.unpack(s)
        if player_sum < self.threshold then
            return HIT
        else
            return STICK
        end
    end
end

local M = {}

M.always_hit = ThresholdPolicy(22)
M.always_stick = ThresholdPolicy(-1)

return M
