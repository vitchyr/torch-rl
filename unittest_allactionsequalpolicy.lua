require 'AllActionsEqualPolicy'
local util = require 'util'
local mdp = require 'TestMdp'
local tester = torch.Tester()

local TestAllActionsEqualPolicy = {}

local function all_actions_have_good_freq(
        action_history,
        all_actions)
    local expected_p = 1. / #all_actions
    for _, action in pairs(all_actions) do
        if not util.elem_has_good_freq(action, action_history, expected_p) then
            return false
        end
    end
    return true
end

function TestAllActionsEqualPolicy.test_policy()
    local policy = AllActionsEqualPolicy(mdp)
    local N = 100000
    local action_history = {}
    for i = 1, N do
        action_history[i] = policy:get_action(nil)
    end

    local all_actions = mdp.get_all_actions()
    tester:assert(
        all_actions_have_good_freq(action_history, all_actions))
end


tester:add(TestAllActionsEqualPolicy)

return tester
