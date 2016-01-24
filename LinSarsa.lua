-- Implement SARSA algorithm using a linear function approximator for on-line
-- policy control
local LinSarsa, parent = torch.class('rl.LinSarsa', 'rl.Sarsa')

function LinSarsa:__init(mdp_config, lambda, explorer, feature_extractor, step_size)
    parent.__init(self, mdp_config, lambda)
    self.explorer = explorer
    self.feature_extractor = feature_extractor
    self.step_size = step_size
    self.q = rl.QLin(self.mdp, self.feature_extractor)
    self.eligibility = rl.QLin(self.mdp, self.feature_extractor)
end

function LinSarsa:get_new_q()
    return rl.QLin(self.mdp, self.feature_extractor)
end

function LinSarsa:reset_eligibility()
    self.eligibility = rl.QLin(self.mdp, self.feature_extractor)
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
    self.policy = rl.GreedyPolicy(
        self.q,
        self.explorer,
        self.actions
    )
end

function LinSarsa:__eq(other)
    return torch.typename(self) == torch.typename(other)
        and self.explorer == other.explorer
        and self.feature_extractor == other.feature_extractor
        and self.step_size == other.step_size
        and self.q == other.q
end
