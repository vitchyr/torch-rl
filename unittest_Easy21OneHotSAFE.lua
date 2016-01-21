require 'Easy21OneHotSAFE'
local ufu = require 'util_for_unittests'

local tester = torch.Tester()

local TestEasy21OneHotSAFE = {}
function TestEasy21OneHotSAFE.test_dim()
    local s = {1, 1}
    local a = {1}
    local fe = Easy21OneHotSAFE()
    local f = fe:get_sa_features(s, a)
    local expected = torch.zeros(fe:get_sa_features_dim())
    tester:assert(ufu.are_tensors_same_shape(f, expected))
end

function TestEasy21OneHotSAFE.test_num_features()
    local s = {1, 1}
    local a = {1}
    local fe = Easy21OneHotSAFE()
    local f = fe:get_sa_features(s, a)
    tester:asserteq(f:numel(), fe:get_sa_num_features())
end

function TestEasy21OneHotSAFE.test_onehot_fe()
    local dealer = 1
    local player = 2
    local s = {dealer, player}
    local a = {1}
    local fe = Easy21OneHotSAFE()
    local f = fe:get_sa_features(s, a)
    local expected = torch.zeros(fe:get_sa_features_dim())
    --- first dimension is action, the player, then dealer
    expected[a[1] + (player-1)*N_ACTIONS + (dealer-1)*(N_ACTIONS*N_PLAYER_STATES)] = 1

    tester:assertTensorEq(f, expected, 0)
end

function TestEasy21OneHotSAFE.test_onehot_fe2()
    local fe = Easy21OneHotSAFE()
    local expected = torch.zeros(fe:get_sa_features_dim())

    local dealer = 4
    local player = 5
    local s = {dealer, player}
    local a = {1}
    local f = fe:get_sa_features(s, a)
    expected[a[1] + (player-1)*N_ACTIONS + (dealer-1)*(N_ACTIONS*N_PLAYER_STATES)] = 1
    tester:assertTensorEq(f, expected, 0)
end

function TestEasy21OneHotSAFE.test_onehot_fe3()
    local fe = Easy21OneHotSAFE()
    local expected = torch.zeros(fe:get_sa_features_dim())

    local dealer = 1
    local player = 20
    local s = {dealer, player}
    local a = {1}
    local f = fe:get_sa_features(s, a)
    expected[a[1] + (player-1)*N_ACTIONS + (dealer-1)*(N_ACTIONS*N_PLAYER_STATES)] = 1
    tester:assertTensorEq(f, expected, 0)
end

function TestEasy21OneHotSAFE.test_onehot_fe4()
    local fe = Easy21OneHotSAFE()
    local expected = torch.zeros(fe:get_sa_features_dim())

    local dealer = 10
    local player = 6
    local s = {dealer, player}
    local a = {2}
    local f = fe:get_sa_features(s, a)
    expected[a[1] + (player-1)*N_ACTIONS + (dealer-1)*(N_ACTIONS*N_PLAYER_STATES)] = 1
    tester:assertTensorEq(f, expected, 0)
end

function TestEasy21OneHotSAFE.test_invalid_state()
    local fe = Easy21OneHotSAFE()

    local s = {-1, 4}
    local a = {2}
    local get_sa_features = function ()
        return fe:get_sa_features(s, a)
    end
    tester:assertError(get_feature)
end

function TestEasy21OneHotSAFE.test_invalid_state2()
    local fe = Easy21OneHotSAFE()

    local s = {1, 4}
    local a = {3}
    local get_sa_features = function ()
        return fe:get_sa_features(s, a)
    end
    tester:assertError(get_feature)
end

tester:add(TestEasy21OneHotSAFE)
tester:run()
