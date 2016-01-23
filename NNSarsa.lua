require 'constants'
require 'QNN'

-- Implement SARSA algorithm using a neural network function approximator for
-- on-line policy control
local NNSarsa, parent = torch.class('rl.NNSarsa', 'rl.Sarsa')

function NNSarsa:__init(mdp_config, lambda, explorer, feature_extractor, step_size)
    parent.__init(self, mdp_config, lambda)
    self.explorer = explorer
    self.feature_extractor = feature_extractor
    self.step_size = step_size
    self.q = QNN(mdp_config:get_mdp(), feature_extractor)
    self.last_state = nil
    self.last_action = nil
    self.momentum = self.lambda * self.discount_factor
end

function NNSarsa:get_new_q()
    return q.QNN:new()
end

function NNSarsa:reset_eligibility()
    self.last_state = nil
    self.last_action = nil
    self.q:reset_momentum()
end

function NNSarsa:update_eligibility(s, a)
    self.last_state = s
    self.last_action = a
end

function NNSarsa:td_update(td_error)
    local learning_rate = td_error * self.step_size
    self.q:backward(
        self.last_state,
        self.last_action,
        learning_rate,
        self.momentum)
end

function NNSarsa:update_policy()
    self.policy = rl.GreedyPolicy(
        self.q,
        self.explorer,
        self.actions
    )
end

function NNSarsa:__eq(other)
    return torch.typename(self) == torch.typename(other)
        and self.explorer == other.explorer
        and self.feature_extractor == other.feature_extractor
        and self.step_size == other.step_size
        and self.q == other.q
        and self.last_state == other.last_state
        and self.last_action == other.last_action
end
