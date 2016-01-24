require 'rl'

local tester = torch.Tester()

local discount_factor = 0.95
local mdp = rl.TestMdp()
local mdp_config = rl.MdpConfig(mdp, discount_factor)
local fe = rl.TestSAFE()
local lambda = 1
local eps = 0.032
local explorer = rl.ConstExplorer(eps)
local step_size = 0.05

local function get_sarsa()
    return rl.NNSarsa(mdp_config, lambda, explorer, fe, step_size)
end

local TestNNSarsa = {}
function TestNNSarsa.test_update_eligibility_one_step()
    local sarsa = get_sarsa()

    local s = 2
    local a = 1
    sarsa:update_eligibility(s, a)

    tester:assert(sarsa.last_state == s and sarsa.last_action == a)
end

function TestNNSarsa.test_td_update_once()
    local sarsa = get_sarsa()
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
    local learning_rate = step_size * td_error
    expected_module:updateParameters(-learning_rate)

    local expected_sarsa = rl.NNSarsa(mdp_config, lambda, explorer, fe, step_size)
    expected_sarsa.q.module = expected_module
    expected_sarsa.last_state = s
    expected_sarsa.last_action = a

    tester:assert(sarsa == expected_sarsa)
end

function TestNNSarsa.test_td_update_many_times()
    local sarsa = get_sarsa()
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
    local learning_rate = step_size * td_error
    expected_module:updateParameters(-learning_rate)

    s = 2
    a = 2
    td_error = -0.6
    sarsa:update_eligibility(s, a)
    sarsa:td_update(td_error)

    input = fe:get_sa_features(s, a)
    expected_module:forward(input)
    grad_out = torch.Tensor{1}
    expected_module:zeroGradParameters()
    expected_module:backward(input, grad_out)
    momentum = lambda * discount_factor
    expected_module:updateGradParameters(momentum, 0, false)
    local learning_rate = step_size * td_error
    expected_module:updateParameters(-learning_rate)

    local expected_sarsa = rl.NNSarsa(mdp_config, lambda, explorer, fe, step_size)
    expected_sarsa.q.module = expected_module
    expected_sarsa.last_state = s
    expected_sarsa.last_action = a

    tester:assert(sarsa == expected_sarsa)
end

function TestNNSarsa.test_reset_eligibility()
    local sarsa = get_sarsa()
    local expected_module = sarsa.q.module:clone()

    if not sarsa.q:is_linear() then
        return
    end

    local s = 2
    local a = 1
    local td_error = -0.4
    local old_value = sarsa.q:get_value(s, a)
    sarsa:update_eligibility(s, a)
    sarsa:td_update(td_error)

    local new_value1 = sarsa.q:get_value(s, a)
    local d_value_1 = new_value1 - old_value

    sarsa:reset_eligibility(s, a)
    sarsa:update_eligibility(s, a)
    sarsa:td_update(td_error)
    local new_value2 = sarsa.q:get_value(s, a)
    local d_value_2 = new_value2 - new_value1

    tester:assert(math.abs(d_value_1 - d_value_2) < rl.FLOAT_EPS)
end

tester:add(TestNNSarsa)

tester:run()

