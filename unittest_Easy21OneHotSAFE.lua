require 'Easy21OneHotSAFE'

local tester = torch.Tester()

local TestEasy21OneHotSAFE = {}
function TestEasy21OneHotSAFE.test_onehot_fe()
    local dealer = 1
    local player = 2
    local s = {dealer, player}
    local a = {1}
    local fe = Easy21OneHotSAFE()
    local f = fe:get_sa_features(s, a)
    local expected = torch.zeros(N_DEALER_STATES * N_PLAYER_STATES * N_ACTIONS)
    --- first dimension is action, the player, then dealer
    expected[a[1] + (player-1)*N_ACTIONS + (dealer-1)*(N_ACTIONS*N_PLAYER_STATES)] = 1

    tester:assertTensorEq(f, expected, 0)
end

function TestEasy21OneHotSAFE.test_onehot_fe2()
    local fe = Easy21OneHotSAFE()
    local expected = torch.zeros(N_DEALER_STATES * N_PLAYER_STATES * N_ACTIONS)

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
    local expected = torch.zeros(N_DEALER_STATES * N_PLAYER_STATES * N_ACTIONS)

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
    local expected = torch.zeros(N_DEALER_STATES * N_PLAYER_STATES * N_ACTIONS)

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
    local expected = torch.zeros(N_DEALER_STATES * N_PLAYER_STATES * N_ACTIONS)

    local s = {-1, 4}
    local a = {2}
    local get_sa_features = function ()
        return fe:get_sa_features(s, a)
    end
    tester:assertError(get_feature)
end

function TestEasy21OneHotSAFE.test_invalid_state2()
    local fe = Easy21OneHotSAFE()
    local expected = torch.zeros(N_DEALER_STATES * N_PLAYER_STATES * N_ACTIONS)

    local s = {1, 4}
    local a = {3}
    local get_sa_features = function ()
        return fe:get_sa_features(s, a)
    end
    tester:assertError(get_feature)
end

tester:add(TestEasy21OneHotSAFE)
tester:run()
