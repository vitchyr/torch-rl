require 'constants'
local qlearning = require 'qlearning'
local q = require 'qnn'
local VHash = require 'vhash'
local fe = require 'featureextraction'
local sarsa = require 'sarsa'

-- Implement SARSA algorithm using a neural network function approximator for
-- on-line policy control
local M = {}

do
    local NS = torch.class('NNSarsa', 'Sarsa')

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
        self.policy = qlearning.const_eps_greedy_improve_policy(self.Q, EPS)
    end
end

M.NNSarsa = NNSarsa
return M
