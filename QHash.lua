mdputil = require 'mdputil'
util = require 'util'

-- A simple implementation of a state-action value function using hashes and
-- tables
local QHash = torch.class('QHash')

function QHash:__init(mdp)
    self.mdp = mdp
    self.hs = function (s) return mdp:hash_s(s) end
    self.ha = function (a) return mdp:hash_a(a) end
    self.q_table = mdputil.get_all_states_action_map(mdp)
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
    local actions = self.mdp:get_all_actions()
    local Qs = self.q_table[self.hs(s)]
    local best_a, best_i = util.max(
        actions,
        function (a) return Qs[self.ha(a)] end)
    return best_a
end
