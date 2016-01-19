require 'constants'
require 'Sarsa'
require 'ConstExplorer'
require 'GreedyPolicy'
require 'QLin'
local fe = require 'featureextraction'

-- Implement SARSA algorithm using a linear function approximator for on-line
-- policy control
local LinSarsa, parent = torch.class('LinSarsa', 'Sarsa')

function LinSarsa:__init(mdp_config, policy, lambda, eps)
    parent.__init(self, mdp_config, policy, lambda)
    eps = eps or EPS
    self.explorer = ConstExplorer(eps)
end

function LinSarsa:get_new_q()
    return QLin()
end

function LinSarsa:reset_eligibility()
    self.eligibility = QLin()
end

function LinSarsa:update_eligibility(s, a)
    local features = fe.get_features(s, a)
    self.eligibility:mult(GAMMA*self.lambda)
    self.eligibility:add(features)
end

function LinSarsa:td_update(td_error)
    self.q:add(self.eligibility:get_weight_vector() * self.alpha * td_error)
end

function LinSarsa:update_policy()
    self.policy = GreedyPolicy(
        self.q,
        self.explorer,
        self.actions
    )
end
