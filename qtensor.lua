require 'constants'

-- A fast implementation of a state-action value function using the fact that
-- the state = pair of numbers and action = a number

local Q = {}

function Q:new()
    local new_q =
        {q_tensor = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES, N_ACTIONS)}
    self.__index = self
    return setmetatable(new_q, self)
end

function Q:get_value(s, a)
    return self.q_tensor[s][a]
end

function Q:add(s, a, delta)
    self.q_tensor[s][a] = self.q_tensor[s][a] + delta
end

function Q:get_v_tensor()
    -- max chooses the best action (action = dimension 3)
    -- select drops the action dimension, so that it's a 
    --      N_DEALER_STATES x N_PLAYER_STATES
    -- tensor rather than a 
    --      N_DEALER_STATES x N_PLAYER_STATES x 1
    -- tensor
    return torch.max(self.q_tensor, 3):select(3, 1)
end

function Q:get_best_action(s)
    best_v, best_a = torch.max(self.q_tensor, 3)
    return best_a[s][1]
end

-- return a function that, given a state, returns its value
function Q:get_v_fn()
    local v_table = self:get_v_tensor()
    return function (s)
        return v_table[s]
    end
end

return Q
