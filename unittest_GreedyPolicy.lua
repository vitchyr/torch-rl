require 'rl'
require 'ConstExplorer'
require 'TestMdp'
require 'QFunc'
local tester = torch.Tester()
local ufu = require 'util_for_unittests'

local TestGreedyPolicy = {}
local mdp = TestMdp()
local q = QFunc()

local function get_policy(best_action, eps)
    local explorer = ConstExplorer(eps)
    q.get_best_action = function (s)
        return best_action
    end
    return rl.GreedyPolicy(q, explorer, mdp:get_all_actions())
end

function TestGreedyPolicy.test_greedy()
    local eps = 0.7
    local policy = get_policy(2, eps)
    local expected_probabilities = {
        eps/3,
        1 - 2*eps/3,
        eps/3
    }
    tester:assert(ufu.are_testmdp_policy_probabilities_good(
        policy,
        expected_probabilities))
end

function TestGreedyPolicy.test_greedy2()
    local eps = 0.05
    local policy = get_policy(1, eps)
    local expected_probabilities = {
        1 - 2*eps/3,
        eps/3,
        eps/3
    }
    tester:assert(ufu.are_testmdp_policy_probabilities_good(
        policy,
        expected_probabilities))
end
tester:add(TestGreedyPolicy)

tester:run()
