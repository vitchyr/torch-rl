envutil = require 'envutil'
util = require 'util'

-- A simple implementation of a state-action value function using hashes and
-- tables
local QHash = torch.class('QHash')

function QHash:__init(env)
    self.env = env
    self.hs = env.hash_s
    self.ha = env.hash_a
    self.q_table = envutil.get_all_states_action_map(env)
end

function QHash:get_value(s, a)
    return self.q_table[self.hs(s)][self.ha(a)]
end

function QHash:mult(s, a, value)
    self.q_table[self.hs(s)][self.ha(a)] = self.q_table[self.hs(s)][self.ha(a)] * value
end

function QHash:add(s, a, delta)
    self.q_table[self.hs(s)][self.ha(a)] = self.q_table[self.hs(s)][self.ha(a)] + delta
end

function QHash:get_best_action(s)
    local actions = self.env.get_all_actions()
    local Qs = self.q_table[self.hs(s)]
    local best_a, best_i = util.max(
        actions,
        function (a) return Qs[self.ha(a)] end)
    return best_a
end
