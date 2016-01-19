require 'QFunc'
local util = require 'util'

-- Abstract class for a Q function approximation class
local QApprox, parent = torch.class('QApprox', 'QFunc')

function QApprox:__init(mdp, feature_extractor)
    parent.__init(self, mdp)
    self.feature_extractor = feature_extractor
end

function QApprox:clear()
    error('Must implement clear method')
end

function QApprox:get_value(s, a)
    error('Must implement get_Value method')
end

function QApprox:add(d_weights)
    error('Must implement add method')
end

function QApprox:mult_all(factor)
    error('Must implement mult_all method')
end

function QApprox:get_weight_vector()
    error('Must implement get_weight_vector method')
end

function QApprox:get_q_tensor()
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

function QApprox:get_best_action(s)
    local actions = self.mdp:get_all_actions()
    local best_a, best_i = util.max(
        actions,
        function (a) return self:get_value(s, a) end)
    return best_a
end

QApprox.__eq = parent.__eq -- force inheritance of this
