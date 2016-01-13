local qlearning = require 'qlearning'

local M = {}

do
    -- Abstract class for implementing SARSA.
    -- Need to implement:
    --
    --  get_new_q()
    --      Return an instance of a Q class.
    --
    --  reset_eligibility()
    --      Clear self.eligibility for a new episode
    --
    --  update_eligibility(s, a)
    --      Update self.eligibility after visiting state s and taking action a
    --
    --  td_update(td_error)
    --      Implement the TD update rule, given a TD error.
    --
    --  update_policy()
    --      Update self.policy.
    --
    local Sarsa = torch.class('Sarsa')

    function Sarsa:__init(lambda, env, alpha)
        self.lambda = lambda
        self.Q = self:get_new_q()
        self.env = env
        self.alpha = alpha or STEP_SIZE
        self.policy = nil

        self:update_policy()
    end

    function Sarsa:run_episode(s, a)
        self:reset_eligibility()
        while s ~= TERMINAL do
            local s_new, r = self.env.step(s, a)
            local td_error, a_new = nil, nil
            if s_new == nil then
                td_error = r - self.Q:get_value(s, a)
            else
                self:update_policy()
                a_new = self.policy(s_new)
                td_error = r + GAMMA*self.Q:get_value(s_new, a_new)
                             - self.Q:get_value(s, a)
            end
            self:update_eligibility(s, a)
            self:td_update(td_error)

            s = s_new
            a = a_new
        end
        self.policy = qlearning.const_eps_greedy_improve_policy(self.Q, EPS)
    end

    function Sarsa:improve(n_iters)
        n_iters = n_iters or 1
        for i = 1, n_iters do
            local s = self.env.get_start_state()
            local a = self.policy(s)
            self:run_episode(s, a)
        end
        return self
    end

    function Sarsa:get_Q()
        return self.Q
    end

    function Sarsa:get_policy()
        return self.policy
    end
end
M.Sarsa = Sarsa

return M
