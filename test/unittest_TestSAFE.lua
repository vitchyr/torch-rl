require 'rl'
local tester = torch.Tester()

local TestTestSAFE = {}
local fe = rl.TestSAFE()
function TestTestSAFE.test_get_sa_features()
    local s = 5
    local a = 2
    local expected = torch.Tensor{7, 3}
    tester:assertTensorEq(fe:get_sa_features(s, a), expected, 0)
end

function TestTestSAFE.test_get_sa_features_dim()
    local s = 5
    local a = 2
    local blank = torch.Tensor(fe:get_sa_features_dim())
    local features = fe:get_sa_features(s, a)
    tester:assert(rl.util.are_tensors_same_shape(blank, features))
end

function TestTestSAFE.test_get_sa_num_features()
    local s = 5
    local a = 2
    local features = fe:get_sa_features(s, a)
    tester:asserteq(fe:get_sa_num_features(), features:numel())
end

tester:add(TestTestSAFE)

tester:run()

