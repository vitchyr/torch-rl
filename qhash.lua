require 'constants'
envutil = require 'envutil'
env = require 'easy21'
util = require 'util'

-- A slow implementation of a state-action value function using hashes and
-- tables

local Q = {}
local hs = env.hash_s
local ha = env.hash_a

function Q:new()
    local new_q =
        {q_table = envutil.get_all_states_action_map(env)}
    self.__index = self
    return setmetatable(new_q, self)
end

function Q:get_value(s, a)
    return self.q_table[hs(s)][ha(a)]
end

function Q:mult(s, a, value)
    self.q_table[hs(s)][ha(a)] = self.q_table[hs(s)][ha(a)] * value
end

function Q:add(s, a, delta)
    self.q_table[hs(s)][ha(a)] = self.q_table[hs(s)][ha(a)] + delta
end

function Q:get_q_tensor()
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

function Q:get_best_action(s)
    local actions = env.get_all_actions()
    local Qs = self.q_table[hs(s)]
    local best_a, best_i = util.max(
        actions,
        function (a) return Qs[ha(a)] end)
    return best_a
end

return Q
