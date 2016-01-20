require 'constants'
require 'Sarsa'
require 'ConstExplorer'
require 'GreedyPolicy'
require 'QLin'

-- Implement SARSA algorithm using a linear function approximator for on-line
-- policy control
local LinSarsa, parent = torch.class('LinSarsa', 'Sarsa')

function LinSarsa:__init(mdp_config, lambda, eps, feature_extractor, step_size)
    parent.__init(self, mdp_config, lambda)
    eps = eps or EPS
    self.explorer = ConstExplorer(eps)
    self.feature_extractor = feature_extractor
    self.step_size = step_size
    self.q = QLin(self.mdp, self.feature_extractor)
end

function LinSarsa:get_new_q()
    return QLin(self.mdp, self.feature_extractor)
end

function LinSarsa:reset_eligibility()
    self.eligibility = QLin(self.mdp, self.feature_extractor)
end

function LinSarsa:update_eligibility(s, a)
    local features = self.feature_extractor:get_sa_features(s, a)
    self.eligibility:mult(self.discount_factor*self.lambda)
    self.eligibility:add(features)
end

function LinSarsa:td_update(td_error)
    self.q:add(self.eligibility:get_weight_vector() * self.step_size * td_error)
end

function LinSarsa:update_policy()
    self.policy = GreedyPolicy(
        self.q,
        self.explorer,
        self.actions
    )
end
