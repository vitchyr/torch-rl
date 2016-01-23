require 'MdpConfig'
require 'TestSAFE'
require 'QLin'
require 'ConstExplorer'
local ufu = require 'util_for_unittests'
local tester = torch.Tester()

local discount_factor = 0.95
local mdp = rl.TestMdp()
local mdp_config = MdpConfig(mdp, discount_factor)
local fe = TestSAFE()

local TestLinSarsa = {}

function TestLinSarsa.test_update_eligibility_one_step()
    local lambda = 1
    local eps = 0.032
    local explorer = ConstExplorer(eps)
    local step_size = 0.05
    local sarsa = rl.LinSarsa(mdp_config, lambda, explorer, fe, step_size)

    local s = 2
    local a = 1
    sarsa:update_eligibility(s, a)

    local eligibility_expected = QLin(mdp, fe)
    eligibility_expected.weights[1] = s + a
    eligibility_expected.weights[2] = s - a

    tester:assert(sarsa.eligibility == eligibility_expected)
end

function TestLinSarsa.test_update_eligibility_many_steps()
    local lambda = 0.5
    local eps = 0.032
    local explorer = ConstExplorer(eps)
    local step_size = 0.05
    local sarsa = rl.LinSarsa(mdp_config, lambda, explorer, fe, step_size)

    local s = 2
    local a = 1
    sarsa:update_eligibility(s, a)

    local eligibility_expected = QLin(mdp, fe)
    eligibility_expected.weights = eligibility_expected.weights 
        + torch.Tensor{s+a, s-a}

    local decay_factor = discount_factor * lambda
    eligibility_expected.weights = eligibility_expected.weights * decay_factor

    s = 2
    a = 2
    sarsa:update_eligibility(s, a)
    eligibility_expected.weights =
        eligibility_expected.weights + torch.Tensor{s+a, s-a}

    eligibility_expected.weights = eligibility_expected.weights * decay_factor

    s = 2
    a = 1
    sarsa:update_eligibility(s, a)
    eligibility_expected.weights =
        eligibility_expected.weights + torch.Tensor{s+a, s-a}

    tester:assert(sarsa.eligibility == eligibility_expected)
end

tester:add(TestLinSarsa)

tester:run()

