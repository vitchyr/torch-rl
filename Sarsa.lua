-- Abstract class for implementing SARSA.
-- See end of file for functions that must be implemented.
local Sarsa, parent = torch.class('rl.Sarsa', 'rl.Control')

function Sarsa:__init(mdp_config, lambda)
    parent.__init(self, mdp_config)
    self.lambda = lambda
    self.q = nil
    self.actions = self.mdp:get_all_actions()
    self.discount_factor = mdp_config:get_discount_factor()
end

function Sarsa:run_episode(s, a)
    self:reset_eligibility()
    -- Can't use sampler because we're updating policy at each step
    while not self.mdp:is_terminal(s) do
        local s_new, r = self.mdp:step(s, a)
        local td_error, a_new = nil, nil
        if s_new == nil then
            td_error = r - self.q:get_value(s, a)
        else
            a_new = self.policy:get_action(s_new)
            td_error = r + self.discount_factor*self.q:get_value(s_new, a_new)
                         - self.q:get_value(s, a)
        end
        self:update_eligibility(s, a)
        self:td_update(td_error)
        self:update_policy()

        s = s_new
        a = a_new
    end
end

function Sarsa:improve_policy()
    local s = self.mdp:get_start_state()
    local a = self.policy:get_action(s)
    self:run_episode(s, a)
end

function Sarsa:get_q()
    return self.q
end

-- Return an instance of a Q class.
function Sarsa:get_new_q()
    error('Must implement get_new_q')
end

-- Clear self.eligibility for a new episode
function Sarsa:reset_eligibility()
    error('Must implement reset_eligibility')
end

-- Update self.eligibility after visiting state s and taking action a
function Sarsa:update_eligibility(s, a)
    error('Must implement update_eligibility')
end

-- Implement the TD update rule, given a TD error.
function Sarsa:td_update(td_error)
    error('Must implement td_error')
end

-- Update self.policy.
function Sarsa:update_policy()
    error('Must implement update_policy')
end
