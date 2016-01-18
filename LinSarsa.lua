require 'constants'
require 'Sarsa'
local q = require 'qlin'
local fe = require 'featureextraction'
local qlearning = require 'qlearning'

-- Implement SARSA algorithm using a linear function approximator for on-line
-- policy control
local LS = torch.class('LinSarsa', 'Sarsa')

function LS:get_new_q()
    return q.QLin:new()
end
function LS:reset_eligibility()
    self.eligibility = q.QLin:new()
end
function LS:update_eligibility(s, a)
    local features = fe.get_features(s, a)
    self.eligibility:mult(GAMMA*self.lambda)
    self.eligibility:add(features)
end
function LS:td_update(td_error)
    self.Q:add(self.eligibility:get_weight_vector() * self.alpha * td_error)
end
function LS:update_policy()
    self.policy = qlearning.const_eps_greedy_improve_policy(self.Q, EPS)
end
