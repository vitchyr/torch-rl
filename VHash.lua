envutil = require 'envutil'

-- A slow implementation of a state value function using hashes and tables

local VHash = torch.class('VHash')

function VHash:__init(env)
    self.v_table = envutil.get_all_states_map(env)
    self.hs = function (s) return env:hash_s(s) end
end

function VHash:get_value(s)
    return self.v_table[self.hs(s)]
end

function VHash:mult(s, value)
    self.v_table[self.hs(s)] = self.v_table[self.hs(s)] * value
end

function VHash:add(s, delta)
    self.v_table[self.hs(s)] = self.v_table[self.hs(s)] + delta
end
