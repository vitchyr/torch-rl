local env = require 'easy21'
local util = require 'util'

local M = {}

do
    -- Abstract class for a Q function approximation class
    local QA = torch.class('QApprox')

    function QA:__init() end
    function QA:clear()
        error('Must implement clear method')
    end
    function QA:get_value(s, a)
        error('Must implement get_Value method')
    end
    function QA:add(d_weights)
        error('Must implement add method')
    end
    function QA:mult_all(factor)
        error('Must implement mult_all method')
    end
    function QA:get_weight_vector()
        error('Must implement get_weight_vector method')
    end
    function QA:get_q_tensor()
        local value = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES, N_ACTIONS)
        for dealer = 1, N_DEALER_STATES do
            for player = 1, N_PLAYER_STATES do
                for a = 1, N_ACTIONS do
                    s = {dealer, player}
                    value[s][a] = self:get_value(s, a)
                end
            end
        end
        return value
    end
    function QA:get_best_action(s)
        local actions = env.get_all_actions()
        local best_a, best_i = util.max(
            actions,
            function (a) return self:get_value(s, a) end)
        return best_a
    end
end
M.QApprox = QApprox

return M
