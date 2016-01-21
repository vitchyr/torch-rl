require 'QNN'
require 'TestSAFE'
require 'TestMdp'
local tester = torch.Tester()

local TestQNN = {}

local mdp = TestMdp()
local fe = TestSAFE()

function TestQNN.test_add_once()
    local alpha = 0.5
    local lambda = 0.9

    local q = QNN(mdp, fe)
    local module = q.module:clone()

    local s = 2
    local a = 4
    local td_error = 1
    q:backward(td_error, s, a, alpha, lambda)
    local new_params = q.module:parameters()

    -- This is kinda cheating since this is basically the same code as the
    -- function, but I also don't see a better way to do this.
    local input = fe:get_sa_features(s, a)
    local grad_out = torch.Tensor{1}
    local _ = module:forward(input)
    module:backward(input, grad_out)
    module:updateParameters(-alpha*td_error)
    local expected_params = module:parameters()

    tester:assertTensorEq(expected_params[1], new_params[1], 0)
    tester:assertTensorEq(expected_params[2], new_params[2], 0)
end

tester:add(TestQNN)

tester:run()
