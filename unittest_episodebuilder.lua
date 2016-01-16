require 'EpisodeBuilder'
local util = require 'util'
local tester = torch.Tester()

local TestEpisodeBuilder = {}
function TestEpisodeBuilder.test_gamma_one()
    local builder = EpisodeBuilder(1)
    local state = 5
    local action = 9

    builder:add_state_action_reward_step(state, action, 1)
    builder:add_state_action_reward_step(state, action, 1)
    builder:add_state_action_reward_step(state, action, 1)
    builder:add_state_action_reward_step(state, action, 1)

    local expected = {
        [1] = {
            state = state,
            action = action,
            discounted_return = 4,
            reward = 1
        },
        [2] = {
            state = state,
            action = action,
            discounted_return = 3,
            reward = 1
        },
        [3] = {
            state = state,
            action = action,
            discounted_return = 2,
            reward = 1
        },
        [4] = {
            state = state,
            action = action,
            discounted_return = 1,
            reward = 1
        }
    }

    tester:assert(util.deepcompare(expected, builder:get_episode()))
end

tester:add(TestEpisodeBuilder)

return tester
