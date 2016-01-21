require 'NNSarsa'
require 'MdpConfig'
require 'TestMdp'
require 'TestSAFE'
require 'ConstExplorer'
local tester = torch.Tester()

local discount_factor = 0.95
local mdp = TestMdp()
local mdp_config = MdpConfig(mdp, discount_factor)
local fe = TestSAFE()

local TestNNSarsa = {}
function TestNNSarsa.test_update_eligibility_one_step()
    local lambda = 1
    local eps = 0.032
    local explorer = ConstExplorer(eps)
    local step_size = 0.05
    local sarsa = NNSarsa(mdp_config, lambda, explorer, fe, step_size)

    local s = 2
    local a = 1
    sarsa:update_eligibility(s, a)

    tester:assert(sarsa.last_state == s and sarsa.last_action == a)
end

function TestNNSarsa.test_td_update_once()
    local lambda = 1
    local eps = 0.032
    local explorer = ConstExplorer(eps)
    local step_size = 0.05
    local sarsa = NNSarsa(mdp_config, lambda, explorer, fe, step_size)
    local expected_module = sarsa.q.module:clone()

    local s = 2
    local a = 1
    local td_error = -0.4
    sarsa:update_eligibility(s, a)
    sarsa:td_update(td_error)

    local input = fe:get_sa_features(s, a)
    expected_module:forward(input)
    local grad_out = torch.Tensor{1}
    expected_module:backward(input, grad_out)
    local momentum = lambda * discount_factor
    expected_module:updateGradParameters(momentum, 0, false)
    local learning_rate = step_size * td_error
    expected_module:updateParameters(-learning_rate)

    local expected_sarsa = NNSarsa(mdp_config, lambda, explorer, fe, step_size)
    expected_sarsa.q.module = expected_module
    expected_sarsa.last_state = s
    expected_sarsa.last_action = a

    tester:assert(sarsa == expected_sarsa)
end

tester:add(TestNNSarsa)

tester:run()

