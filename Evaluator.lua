require 'constants'

local Evaluator = torch.class('Evaluator')

function Evaluator.__init(self, agent)
    self.agent = agent
end

function Evaluator:get_policy_avg_return(policy, n_iters)
    local total_r = 0
    for i = 1, n_iters do
        total_r = total_r + self.agent:sample_reward(policy)
    end
    return total_r
end

function Evaluator:display_metrics(policy, description, n_iters)
    n_iters = n_iters or N_ITERS
    local total_r = self:get_policy_avg_return(policy, n_iters)
    print('Avg Reward for <' .. description .. '>: ' ..
            total_r .. '/' .. n_iters .. ' = ' ..  total_r/n_iters)
end
