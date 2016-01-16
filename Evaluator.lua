require 'constants'

local M = {}

do
    local Evaluator = torch.class('Evaluator')

    function Evaluator.__init(self, agent)
        self.agent = agent
    end

    function Evaluator:getPolicyAvgReturn(policy, n_iters)
        local total_r = 0
        for i = 1, n_iters do
            total_r = total_r + self.agent:sample_reward(policy)
        end
        return total_r
    end

    function Evaluator:displayMetrics(policy, description, n_iters)
        n_iters = n_iters or N_ITERS
        local totalR = self:getPolicyAvgReturn(policy, N_ITERS)
        print('Avg Reward for ' .. description .. ': ' ..
                totalR .. '/' .. N_ITERS .. ' = ' ..  totalR/N_ITERS)
    end
end
M.Evaluator = Evaluator

return M
