require 'constants'
require 'Agent'
require 'ThresholdPolicy'

local easy21 = require 'easy21'

local tester = torch.Tester()

local TestAgent = {}

local function get_threshold_episode(policy)
    local a = Agent(easy21)
    return a:get_episode(policy)
end

local function is_discount_good(episode)
    local data = episode[1]
    local _, _, last_Gt = table.unpack(data)
    for t, data in pairs(episode) do
        local s, a, Gt = table.unpack(data)
        if GAMMA * Gt ~= last_Gt then
            return false
        end
        last_Gt = Gt
    end
    return true
end

function TestAgent.test_get_episode_discounted_reward()
    local episode = get_threshold_episode(ThresholdPolicy(12))
    tester:assert(is_discount_good(episode))
end

tester:add(TestAgent)

return tester
