-- A slow implementation of a state value function using hashes and tables

local VHash, parent = torch.class('rl.VHash', 'rl.VFunc')

function VHash:__init(mdp)
    parent.__init(self, mdp)
    self.v_table = rl.util.get_all_states_map(mdp)
    self.hs = function (s) return mdp:hash_s(s) end
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

VHash.__eq = parent.__eq
