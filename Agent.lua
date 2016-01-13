local envutil = require 'envutil'
local VHash = require 'vhash'

local M = {}
do
    local Agent = torch.class('Agent')
    function Agent:__init(env)
        self.env = env
    end

    -- policy: a function that takes in a state and returns an action
    function Agent:sample_reward(policy)
        local s = self.env.get_start_state()
        local total_r, r = 0, 0
        while s ~= TERMINAL do
            s, r = self.env.step(s, policy(s))
            total_r = total_r + r
        end
        return total_r
    end

    local function update_past_rewards(eligibility, r, episode)
        for t = 1, #episode do
            s = episode[t][1]
            if eligibility == nil then
                episode[t][3] = episode[t][3] + r
            else
                episode[t][3] = episode[t][3] + eligibility:get_value(s) * r
            end
        end
        return episode
    end

    -- Episode: list of {state, action, discounted return, reward}
    function Agent:get_episode(policy)
        local episode = {}
        local s = self.env.get_start_state()
        local r = 0
        local a = nil
        local last_s = self.env.copy_state(s)
        local eligibility = nil
        if GAMMA ~= 1 then
            eligibility = VHash:new()
        end

        local t = 1
        while s ~= TERMINAL do
            if GAMMA ~= 1 then
                for _, ss in pairs(self.env.get_all_states()) do
                    eligibility:mult(ss, GAMMA)
                end
                eligibility:add(s, 1)
            end
            a = policy(s)
            s, r = self.env.step(s, a)
            episode[t] = {last_s, a, 0, r}
            if r ~= 0 then
                episode = update_past_rewards(eligibility, r, episode)
            end
            last_s = self.env.copy_state(s)
            t = t + 1
        end

        return episode
    end
end

M.Agent = Agent

return M
