require 'rl'
require 'constants'
require 'MdpSampler'
require 'MdpConfig'

local tester = torch.Tester()

local TestMdpSampler = {}

local function get_sampler(discount_factor)
    local config = MdpConfig(rl.TestMdp(), discount_factor)
    return MdpSampler(config)
end

local function get_policy_episode(policy, discount_factor)
    local sampler = get_sampler(discount_factor)
    return sampler:get_episode(policy)
end

local function is_discount_good(episode, discount_factor)
    local data = episode[1]
    local last_Gt = data.discounted_return
    local last_r = data.reward
    for t = 2, #episode do
        data = episode[t]

        local s = data.state
        local a = data.action
        local Gt = data.discounted_return
        local r = data.reward
        if last_Gt ~= last_r + discount_factor * Gt then
            return false
        end

        last_Gt = Gt
        last_r = r
    end
    return true
end

function TestMdpSampler.test_get_episode_discounted_reward()
    local discount_factor = 1
    local episode = get_policy_episode(rl.TestPolicy(1), discount_factor)
    tester:assert(is_discount_good(episode, discount_factor))

    local discount_factor = 0.5
    local episode = get_policy_episode(rl.TestPolicy(1), discount_factor)
    tester:assert(is_discount_good(episode, discount_factor))

    local discount_factor = 0
    local episode = get_policy_episode(rl.TestPolicy(1), discount_factor)
    tester:assert(is_discount_good(episode, discount_factor))
end

function TestMdpSampler.test_discounted_reward_error()
    local discount_factor = 2
    local get_config = function ()
        return MdpConfig(TestMdp, discount_factor)
    end
    tester:assertError(get_config)

    discount_factor = -1
    get_config = function ()
        return MdpConfig(TestMdp, discount_factor)
    end
    tester:assertError(get_config)
end

function TestMdpSampler.test_sample_return_always_one()
    local policy = rl.TestPolicy(1)

    local discount_factor = 1
    local sampler = get_sampler(discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), -2)

    local discount_factor = 0
    local sampler = get_sampler(discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), -2)

    local discount_factor = 0.5
    local sampler = get_sampler(discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), -2)
end

function TestMdpSampler.test_sample_return_always_two()
    local policy = rl.TestPolicy(2)

    local discount_factor = 1
    local sampler = get_sampler(discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), 0)

    local discount_factor = 0
    local sampler = get_sampler(discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), 0)

    local discount_factor = 0.5
    local sampler = get_sampler(discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), 0)
end

function TestMdpSampler.test_sample_return_always_three()
    local policy = rl.TestPolicy(3)

    local discount_factor = 1
    local sampler = get_sampler(discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), 2)

    local discount_factor = 0
    local sampler = get_sampler(discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), 2)

    local discount_factor = 0.5
    local sampler = get_sampler(discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), 2)
end

local function is_action_good(episode, expected)
    local policy = rl.TestPolicy(expected)
    local discount_factor = 1

    local episode = get_policy_episode(policy, discount_factor)
    for t, data in pairs(episode) do
        if data.action ~= expected then
            return false
        end
    end
    return true
end

function TestMdpSampler.test_action_is_good()
    tester:assert(is_action_good(episode, 1))
end

function TestMdpSampler.test_action_is_good2()
    tester:assert(is_action_good(episode, 2))
end

function TestMdpSampler.test_action_is_good3()
    tester:assert(is_action_good(episode, 3))
end


function TestMdpSampler.test_episode()
    local policy = rl.TestPolicy(1)
    local discount_factor = 1
    local episode = get_policy_episode(policy, discount_factor)

    tester:assert(#episode == 2)
    tester:assert(episode[1].state == 1)
    tester:assert(episode[1].action == 1)
    tester:assert(episode[1].discounted_return == -2)
    tester:assert(episode[1].reward == -1)
    tester:assert(episode[2].state == 2)
    tester:assert(episode[2].action == 1)
    tester:assert(episode[2].discounted_return == -1)
    tester:assert(episode[2].reward == -1)
end

tester:add(TestMdpSampler)

tester:run()
