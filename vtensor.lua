require 'constants'

-- Represent a state-value function with tensors

local V = {}

function V:new()
    local new_v =
        {v_tensor = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES)}
    self.__index = self
    return setmetatable(new_v, self)
end

function V:get_value(s)
    return self.v_tensor[s]
end

function V:add(s, delta)
    self.v_tensor[s] = self.v_tensor[s] + delta
end

return V
