require 'constants'
local qlearning = require 'qlearning'
local QHash = require 'qhash'
local VHash = require 'vhash'
local fe = require 'featureextraction'
local Sarsa = require 'sarsa'

-- Implement SARSA algorithm using a linear function approximator for on-line
-- policy control
local M = {}

do
    local TS, parent = torch.class('TableSarsa', 'Sarsa')
    function TS:__init(lambda, env, alpha)
        self.Ns = VHash:new() -- call this first so that update_policy works
        parent.__init(self, lambda, env, alpha)
        self.Nsa = QHash:new()
    end

    function TS:get_new_q()
        return QHash:new()
    end
    function TS:reset_eligibility()
        self.eligibility = QHash:new()
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
end


M.TableSarsa = TableSarsa
return M
