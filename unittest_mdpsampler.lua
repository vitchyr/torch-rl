require 'constants'
require 'MdpSampler'
require 'TestMdp'
local tp = require 'TestPolicy'

local tester = torch.Tester()

local TestMdpSampler = {}

local function get_policy_episode(policy, discount_factor)
    local sampler = MdpSampler(TestMdp(), discount_factor)
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
    local episode = get_policy_episode(tp.always_one, discount_factor)
    tester:assert(is_discount_good(episode, discount_factor))

    local discount_factor = 0.5
    local episode = get_policy_episode(tp.always_one, discount_factor)
    tester:assert(is_discount_good(episode, discount_factor))

    local discount_factor = 0
    local episode = get_policy_episode(tp.always_one, discount_factor)
    tester:assert(is_discount_good(episode, discount_factor))
end

function TestMdpSampler.test_discounted_reward_error()
    local discount_factor = 2
    tester:assertError(MdpSampler(TestMdp(), discount_factor))

    local discount_factor = -1
    tester:assertError(MdpSampler(TestMdp(), discount_factor))
end

function TestMdpSampler.test_sample_return_always_one()
    local policy = tp.always_one

    local discount_factor = 1
    local sampler = MdpSampler(TestMdp(), discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), -2)

    local discount_factor = 0
    local sampler = MdpSampler(TestMdp(), discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), -2)

    local discount_factor = 0.5
    local sampler = MdpSampler(TestMdp(), discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), -2)
end

function TestMdpSampler.test_sample_return_always_two()
    local policy = tp.always_two

    local discount_factor = 1
    local sampler = MdpSampler(TestMdp(), discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), 0)

    local discount_factor = 0
    local sampler = MdpSampler(TestMdp(), discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), 0)

    local discount_factor = 0.5
    local sampler = MdpSampler(TestMdp(), discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), 0)
end

function TestMdpSampler.test_sample_return_always_three()
    local policy = tp.always_three

    local discount_factor = 1
    local sampler = MdpSampler(TestMdp(), discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), 2)

    local discount_factor = 0
    local sampler = MdpSampler(TestMdp(), discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), 2)

    local discount_factor = 0.5
    local sampler = MdpSampler(TestMdp(), discount_factor)
    tester:asserteq(sampler:sample_total_reward(policy), 2)
end

tester:add(TestMdpSampler)

return tester
