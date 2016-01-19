require 'constants'
require 'Sarsa'
local q = require 'qnn'
local fe = require 'featureextraction'

-- Implement SARSA algorithm using a neural network function approximator for
-- on-line policy control
local NS = torch.class('NNSarsa', 'Sarsa')

function TableSarsa:__init(mdp_config, policy, lambda, eps)
    parent.__init(self, mdp_config, policy, lambda)
    eps = eps or EPS
    self.explorer = ConstExplorer(eps)
end

function NS:get_new_q()
    return q.QNN:new()
end

function NS:reset_eligibility()
end

function NS:update_eligibility(s, a)
    self.last_s = s
    self.last_a = a
end

function NS:td_update(td_error)
    self.Q:backward(td_error, self.last_s, self.last_a, self.alpha, self.lambda)
end

function NS:update_policy()
    self.policy = GreedyPolicy(
        self.q,
        self.explorer,
        self.actions
    )
end
