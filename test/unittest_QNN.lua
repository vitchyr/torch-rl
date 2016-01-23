require 'rl'
require 'constants'
local tester = torch.Tester()

local TestQNN = {}

local mdp = rl.TestMdp()
local fe = rl.TestSAFE()

function TestQNN.test_backward()
    local q = rl.QNN(mdp, fe)
    local module = q.module:clone()

    local s = 2
    local a = 4

    local step_size = 0.5
    local lambda = 0
    local discount_factor = 0.5
    local td_error = 1
    local learning_rate = step_size * td_error
    local momentum = lambda * discount_factor
    q:backward(s, a, learning_rate, momentum)
    local new_params = q.module:parameters()

    -- This is kinda cheating since this is basically the same code as the
    -- function, but I also don't see a better way to do this.
    local input = fe:get_sa_features(s, a)
    local grad_out = torch.Tensor{1}
    local _ = module:forward(input)
    module:backward(input, grad_out)
    module:updateGradParameters(momentum, 0, false)
    module:updateParameters(-step_size*td_error)
    local expected_params = module:parameters()

    tester:assertTensorEq(expected_params[1], new_params[1], 0)
    tester:assertTensorEq(expected_params[2], new_params[2], 0)
end

function TestQNN.test_backward_no_momentum()
    local q = rl.QNN(mdp, fe)
    if not q:is_linear() then
        return
    end

    local module = q.module:clone()

    local s = 2
    local a = 4
    local old_value = q:get_value(s, a)

    local step_size = 0.5
    local td_error = 1
    local learning_rate = step_size * td_error
    local momentum = 0

    q:backward(s, a, learning_rate, momentum)
    local new_value1 = q:get_value(s, a)
    local d_value_1 = new_value1 - old_value

    q:backward(s, a, learning_rate, momentum)
    local new_value2 = q:get_value(s, a)
    local d_value_2 = new_value2 - new_value1

    tester:assert(math.abs(d_value_1 - d_value_2) < FLOAT_EPS)
end

function TestQNN.test_backward_with_momentum()
    local q = rl.QNN(mdp, fe)
    if not q:is_linear() then
        return
    end
    local module = q.module:clone()

    local s = 2
    local a = 4
    local old_value = q:get_value(s, a)

    local step_size = 0.5
    local lambda = 1
    local discount_factor = 1
    local td_error = 1
    local learning_rate = step_size * td_error
    local momentum = lambda * discount_factor

    q:backward(s, a, learning_rate, momentum)
    local new_value1 = q:get_value(s, a)
    local d_value_1 = new_value1 - old_value

    q:backward(s, a, learning_rate, momentum)
    local new_value2 = q:get_value(s, a)
    local d_value_2 = new_value2 - new_value1

    tester:assert(math.abs((1+momentum)*d_value_1 - d_value_2) < FLOAT_EPS)
end

function TestQNN.test_momentum_exists()
    local q = rl.QNN(mdp, fe)
    -- If q is non-linear, then all bets are off on whether or not the momentum
    -- will change things.
    if not q:is_linear() then
        return
    end
    local module = q.module:clone()

    local s = 2
    local a = 4
    local old_value = q:get_value(s, a)

    local step_size = 0.5
    local lambda = 1
    local discount_factor = 1
    local td_error = 1
    local learning_rate = step_size * td_error
    local momentum = lambda * discount_factor

    q:backward(s, a, learning_rate, momentum)
    local new_value1 = q:get_value(s, a)
    local d_value_1 = new_value1 - old_value

    q:backward(s, a, learning_rate, momentum)
    local new_value2 = q:get_value(s, a)
    local d_value_2 = new_value2 - new_value1

    tester:assert(math.abs(d_value_1 - d_value_2) > FLOAT_EPS)
end

function TestQNN.test_backward_reset_momentum()
    local q = rl.QNN(mdp, fe)
    if not q:is_linear() then
        return
    end
    local module = q.module:clone()

    local s = 2
    local a = 4
    local old_value = q:get_value(s, a)

    local step_size = 0.5
    local td_error = 1
    local learning_rate = step_size * td_error
    local momentum = 1

    q:backward(s, a, learning_rate, momentum)
    local new_value1 = q:get_value(s, a)
    local d_value_1 = new_value1 - old_value

    q:reset_momentum()

    q:backward(s, a, learning_rate, momentum)
    local new_value2 = q:get_value(s, a)
    local d_value_2 = new_value2 - new_value1

    tester:assert(math.abs(d_value_1 - d_value_2) < FLOAT_EPS)
end

tester:add(TestQNN)

tester:run()
