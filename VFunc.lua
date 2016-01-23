util = require 'util'

local VFunc = torch.class('rl.VFunc')

function VFunc:__init(mdp)
    self.mdp = mdp
end

function VFunc:get_value(s)
    error('Must implement get_Value method')
end

function VFunc:__eq(other)
    for _, s in pairs(self.mdp:get_all_states()) do
        if self:get_value(s) ~= other:get_value(s) then
            return false
        end
    end
    return true
end
