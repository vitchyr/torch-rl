require 'constants'
require 'Sarsa'
require 'QHash'
require 'VHash'
require 'ConstExplorer'
require 'GreedyPolicy'

-- Implement SARSA algorithm using a linear function approximator for on-line
-- policy control
local TableSarsa, parent = torch.class('TableSarsa', 'Sarsa')
function TableSarsa:__init(mdp_config, policy, lambda, eps)
    parent.__init(self, mdp_config, policy, lambda)
    self.Ns = VHash(self.mdp)
    self.Nsa = QHash(self.mdp)
    eps = eps or EPS
    self.explorer = ConstExplorer(eps)
end

function TableSarsa:get_new_q()
    return QHash(self.mdp)
end
function TableSarsa:reset_eligibility()
    self.eligibility = QHash(self.mdp)
end
function TableSarsa:update_eligibility(s, a)
    for _, ss in pairs(self.mdp:get_all_states()) do
        for _, aa in pairs(self.mdp:get_all_actions()) do
            self.eligibility:mult(ss, aa, GAMMA*self.lambda)
        end
    end
    self.eligibility:add(s, a, 1)
    self.Ns:add(s, 1)
    self.Nsa:add(s, a, 1)
    self.alpha = 1. / self.Nsa:get_value(s, a)
end
function TableSarsa:td_update(td_error)
    for _, ss in pairs(self.mdp:get_all_states()) do
        for _, aa in pairs(self.mdp:get_all_actions()) do
            self.Q:add(ss, aa, self.alpha * td_error * self.eligibility:get_value(ss, aa))
        end
    end
end
function TableSarsa:update_policy()
    self.policy = GreedyPolicy(
        self.Q,
        self.explorer,
        self.actions
    )
end
