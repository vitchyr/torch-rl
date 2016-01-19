require 'constants'
local tp = require 'ThresholdPolicy'
require 'Easy21'

local tester = torch.Tester()
local TestThresholdPolicy = {}

local easy21 = Easy21()

local function get_random_state()
    return {torch.random(-5, 30), torch.random(-5, 30)}
end

local function check_all_states(policy, pass_condition)
    for _, state in pairs(easy21:get_all_states()) do
        local action = policy:get_action(state)
        if not pass_condition(state, action) then
            return false
        end
    end
    return true
end

function TestThresholdPolicy.test_alwayshit()
    local function is_hit(state, action)
        return action == HIT
    end
    tester:assert(check_all_states(tp.always_hit, is_hit))
end

function TestThresholdPolicy.test_alwaystick()
    local function is_stick(state, action)
        return action == STICK
    end
    tester:assert(check_all_states(tp.always_stick, is_stick))
end

local function test_threshold(threshold)
    local policy = ThresholdPolicy(threshold)
    local function satisfies_threshold(state, action)
        local dealer, player = table.unpack(state)
        if player < threshold then
            return action == HIT
        else
            return action == STICK
        end
    end
    tester:assert(check_all_states(policy, satisfies_threshold))
end

function TestThresholdPolicy.test_thresholds()
    for threshold = -1, 22 do
        test_threshold(threshold)
    end
end

tester:add(TestThresholdPolicy)

tester:run()
