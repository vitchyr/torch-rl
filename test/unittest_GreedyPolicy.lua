require 'rl'
local tester = torch.Tester()

local TestGreedyPolicy = {}
local mdp = rl.TestMdp()
local q = rl.QFunc()

local function get_policy(best_action, eps)
    local explorer = rl.ConstExplorer(eps)
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
    tester:assert(rl.util.are_testmdp_policy_probabilities_good(
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
    tester:assert(rl.util.are_testmdp_policy_probabilities_good(
        policy,
        expected_probabilities))
end
tester:add(TestGreedyPolicy)

tester:run()
