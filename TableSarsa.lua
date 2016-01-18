require 'constants'
require 'Sarsa'
require 'QHash'
require 'VHash'
local qlearning = require 'qlearning'
local fe = require 'featureextraction'

-- Implement SARSA algorithm using a linear function approximator for on-line
-- policy control
local TS, parent = torch.class('TableSarsa', 'Sarsa')
function TS:__init(lambda, env, alpha)
    self.Ns = VHash(env) -- call this first so that update_policy works
    parent.__init(self, lambda, env, alpha)
    self.Nsa = QHash(env)
end

function TS:get_new_q()
    return QHash(self.env)
end
function TS:reset_eligibility()
    self.eligibility = QHash(self.env)
end
function TS:update_eligibility(s, a)
    for _, ss in pairs(self.env:get_all_states()) do
        for _, aa in pairs(self.env:get_all_actions()) do
            self.eligibility:mult(ss, aa, GAMMA*self.lambda)
        end
    end
    self.eligibility:add(s, a, 1)
    self.Ns:add(s, 1)
    self.Nsa:add(s, a, 1)
    self.alpha = 1. / self.Nsa:get_value(s, a)
end
function TS:td_update(td_error)
    for _, ss in pairs(self.env:get_all_states()) do
        for _, aa in pairs(self.env:get_all_actions()) do
            self.Q:add(ss, aa, self.alpha * td_error * self.eligibility:get_value(ss, aa))
        end
    end
end
function TS:update_policy()
    self.policy = qlearning.eps_greedy_improve_policy(self.Q, self.Ns)
end
