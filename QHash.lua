-- A simple implementation of a state-action value function using hashes and
-- tables
local QHash, parent = torch.class('rl.QHash', 'rl.QFunc')

function QHash:__init(mdp)
    parent.__init(self, mdp)
    self.hs = function (s) return mdp:hash_s(s) end
    self.ha = function (a) return mdp:hash_a(a) end
    self.q_table = rl.util.get_all_states_action_map(mdp)
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

-- Weird. For some reason this is needed
QHash.__eq = parent.__eq
