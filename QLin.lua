require 'constants'
local util = require 'util'

-- Implementation of a state-action value function approx using linear function
-- of features
local QLin, parent = torch.class('rl.QLin', 'rl.QApprox')

function QLin:__init(mdp, feature_extractor)
    parent.__init(self, mdp, feature_extractor)
    self.weights = torch.zeros(feature_extractor:get_sa_features_dim())
end

function QLin:clear()
    self.weights = torch.zeros(self.feature_extractor:get_sa_features_dim())
end

function QLin:get_value(s, a)
    return self.weights:dot(self.feature_extractor:get_sa_features(s, a))
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

QLin.__eq = parent.__eq -- force inheritance of this
