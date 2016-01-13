require 'constants'
envutil = require 'envutil'
env = require 'easy21'
util = require 'util'

-- A slow implementation of a state-action value function using hashes and
-- tables

local V = {}
local hs = env.hash_s
local ha = env.hash_a

function V:new()
    local new_v = {v_table = envutil.get_all_states_map(env)}
    self.__index = self
    return setmetatable(new_v, self)
end

function V:get_value(s)
    return self.v_table[hs(s)]
end

function V:mult(s, value)
    self.v_table[hs(s)] = self.v_table[hs(s)] * value
end

function V:add(s, delta)
    self.v_table[hs(s)] = self.v_table[hs(s)] + delta
end

function V:get_v_tensor()
    local value = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES)
    for dealer = 1, N_DEALER_STATES do
        for player = 1, N_PLAYER_STATES do
            s = {dealer, player}
            value[s] = self:get_value(s)
        end
    end
    return value
end

return V
