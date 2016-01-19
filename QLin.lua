require 'constants'
require 'QApprox'
local util = require 'util'
local fe = require 'featureextraction'

-- Implementation of a state-action value function approx using linear function
-- of features
local QLin, parent = torch.class('QLin', 'QApprox')

function QLin:__init(mdp)
    parent.__init(self, mdp)
    self.weights = torch.rand(N_FEATURES)
end

function QLin:clear()
    self.weights = torch.zeros(N_FEATURES)
end

function QLin:get_value(s, a)
    return self.weights:dot(fe.get_features(s, a))
end

function QLin:add(d_weights)
    self.weights = self.weights + d_weights
end

function QLin:mult(factor)
    self.weights = self.weights * factor
end

function QLin:get_weight_vector()
    return self.weights
end

QHash.__eq = parent.__eq -- force inheritance of this
