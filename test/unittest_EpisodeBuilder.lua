require 'rl'
local tester = torch.Tester()

local TestEpisodeBuilder = {}
function are_discounted_return_good(
        discount_factor,
        rewards,
        expected_discounted_returns)
    local builder = rl.EpisodeBuilder(discount_factor)
    local state = 5
    local action = 9

    for _, r in pairs(rewards) do
        builder:add_state_action_reward_step(state, action, r)
    end

    local expected = {}
    for i, expected_discounted_return in pairs(expected_discounted_returns) do
        expected[i] = {
            state = state,
            action = action,
            discounted_return = expected_discounted_return,
            reward = rewards[i]
        }
    end

    return rl.util.deepcompare(expected, builder:get_episode())
end
function TestEpisodeBuilder.test_gamma_one()
    local discount_factor = 1
    local rewards = {1, 1, 1, 1}
    local expected_discounted_returns = {4, 3, 2, 1}
    tester:assert(are_discounted_return_good(discount_factor,
                                             rewards,
                                             expected_discounted_returns))
end

function TestEpisodeBuilder.test_gamma_zero()
    local discount_factor = 0
    local rewards = {1, 1, 1, 1}
    local expected_discounted_returns = {1, 1, 1, 1}
    tester:assert(are_discounted_return_good(discount_factor,
                                             rewards,
                                             expected_discounted_returns))
end

function TestEpisodeBuilder.test_gamma_fraction()
    local discount_factor = 0.5
    local rewards = {1, 1, 1, 1}
    local expected_discounted_returns = {
        1 + 0.5 * (1 + 0.5 * (1+0.5)),
        1 + 0.5 * (1 + 0.5),
        1 + 0.5,
        1}
    tester:assert(are_discounted_return_good(discount_factor,
                                             rewards,
                                             expected_discounted_returns))
end

tester:add(TestEpisodeBuilder)

tester:run()
