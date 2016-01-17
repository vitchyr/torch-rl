require 'constants'
require 'MdpSampler'
require 'TestMdp'
local tp = require 'TestPolicy'

local tester = torch.Tester()

local TestMdpSampler = {}

local function get_policy_episode(policy)
    local sampler = MdpSampler(TestMdp())
    return sampler:get_episode(policy)
end

local function is_discount_good(episode)
    local data = episode[1]
    local last_Gt = data.discounted_return
    local last_r = data.reward
    for t = 2, #episode do
        data = episode[t]

        local s = data.state
        local a = data.action
        local Gt = data.discounted_return
        local r = data.reward
        if last_Gt ~= last_r + GAMMA * Gt then
            return false
        end

        last_Gt = Gt
        last_r = r
    end
    return true
end

function TestMdpSampler.test_get_episode_discounted_reward()
    local episode = get_policy_episode(tp.always_one)
    tester:assert(is_discount_good(episode))
end

tester:add(TestMdpSampler)

return tester
