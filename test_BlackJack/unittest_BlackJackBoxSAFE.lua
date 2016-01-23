require 'BlackJackBoxSAFE'
local ufu = require 'util_for_unittests'

local tester = torch.Tester()

local TestBlackJackBoxSAFE = {}
function TestBlackJackBoxSAFE.test_dim()
    local s = {1, 1}
    local a = {1}
    local fe = BlackJackBoxSAFE()
    local f = fe:get_sa_features(s, a)
    local expected = torch.zeros(fe:get_sa_features_dim())
    tester:assert(ufu.are_tensors_same_shape(f, expected))
end

function TestBlackJackBoxSAFE.test_num_features()
    local s = {1, 1}
    local a = {1}
    local fe = BlackJackBoxSAFE()
    local f = fe:get_sa_features(s, a)
    tester:asserteq(f:numel(), fe:get_sa_num_features())
end

function TestBlackJackBoxSAFE.test_onehot_fe()
    local s = {1, 2}
    local a = {1}
    local fe = BlackJackBoxSAFE()
    local f = fe:get_sa_features(s, a)
    local expected = torch.zeros(fe:get_sa_features_dim())
    expected[1] = 1

    tester:assertTensorEq(f, expected, 0)
end

function TestBlackJackBoxSAFE.test_manyhot_fe()
    local s = {4, 5}
    local a = {1}
    local fe = BlackJackBoxSAFE()
    local f = fe:get_sa_features(s, a)
    local expected = torch.zeros(fe:get_sa_features_dim())
    expected[1] = 1
    expected[3] = 1
    expected[13] = 1
    expected[15] = 1

    tester:assertTensorEq(f, expected, 0)
end

function TestBlackJackBoxSAFE.test_invalid_state()
    local fe = BlackJackBoxSAFE()
    local expected = torch.zeros(fe:get_sa_features_dim())

    local s = {-1, 4}
    local a = {2}
    local get_sa_features = function ()
        return fe:get_sa_features(s, a)
    end
    tester:assertError(get_feature)
end

function TestBlackJackBoxSAFE.test_invalid_state2()
    local fe = BlackJackBoxSAFE()
    local expected = torch.zeros(fe:get_sa_features_dim())

    local s = {1, 4}
    local a = {3}
    local get_sa_features = function ()
        return fe:get_sa_features(s, a)
    end
    tester:assertError(get_feature)
end

tester:add(TestBlackJackBoxSAFE)
tester:run()
