require 'rl'
require 'constants'
require 'MdpConfig'
local ufu = require 'util_for_unittests'

math.randomseed(os.time())
local tester = torch.Tester()

local TestMonteCarloControl = {}
function TestMonteCarloControl.test_evalute_policy()
    local mdp = rl.TestMdp()
    local discount_factor = 1
    -- With this policy, the episode will be:
    -- Step 1
    --      state: 1
    --      action: 1
    --      reward: -1
    --      Gt: -2
    --
    -- Step 2
    --      state 2: 2
    --      action 1: 1
    --      reward 1: -1
    --      Gt 1: -1
    local policy = rl.TestPolicy(1)
    local config = MdpConfig(mdp, discount_factor)
    local mcc = rl.MonteCarloControl(config)
    mcc:set_policy(policy)
    mcc:evaluate_policy()

    local expected = rl.MonteCarloControl(config)
    local q = QHash(mdp)
    q:add(1, 1, -2)
    q:add(2, 1, -1)
    local Ns = VHash(mdp)
    Ns:add(1, 1)
    Ns:add(2, 1)
    local Nsa = QHash(mdp)
    Nsa:add(1, 1, 1)
    Nsa:add(2, 1, 1)
    local N0 = N0
    expected.q = q
    expected.Ns = Ns
    expected.Nsa = Nsa
    expected.N0 = N0

    tester:assert(mcc == expected)
end

function TestMonteCarloControl.test_optimize_policy()
    local mdp = rl.TestMdp()
    local discount_factor = 1
    local config = MdpConfig(mdp, discount_factor)
    local mcc = rl.MonteCarloControl(config)
    local q = QHash(mdp)
    q:add(1, 1, 100) -- make action "1" be the best action
    q:add(2, 1, 100)
    local Ns = VHash(mdp)
    local n_times_states_visited = 10 -- make other actions seem really explored
    Ns:add(1, n_times_states_visited) 
    Ns:add(2, n_times_states_visited)
    local N0 = 1

    mcc.q = q
    mcc.Ns = Ns
    mcc.N0 = N0
    mcc:optimize_policy()

    local policy = mcc:get_policy()

    local expected_eps = N0 / (N0 + n_times_states_visited)
    local expected_probabilities = {
        1 - 2* expected_eps / 3,
        expected_eps / 3,
        expected_eps / 3
    }

    tester:assert(ufu.are_testmdp_policy_probabilities_good(
        policy,
        expected_probabilities))
end

tester:add(TestMonteCarloControl)

tester:run()
