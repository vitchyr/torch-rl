util = require 'util'

local QFunc = torch.class('rl.QFunc')

function QFunc:__init(mdp)
    self.mdp = mdp
end

function QFunc:get_value(s, a)
    error('Must implement get_Value method')
end

function QFunc:get_best_action(s)
    local actions = self.mdp:get_all_actions()
    local Qs = self.q_table[self.hs(s)]
    local best_a, best_i = util.max(
        actions,
        function (a) return Qs[self.ha(a)] end)
    return best_a
end

function QFunc:__eq(other)
    for _, s in pairs(self.mdp:get_all_states()) do
        for _, a in pairs(self.mdp:get_all_actions()) do
            if self:get_value(s, a) ~= other:get_value(s, a) then
                return false
            end
        end
    end
    return true
end
