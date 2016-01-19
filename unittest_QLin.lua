require 'QLin'
require 'Easy21'
require 'easy21_constants'
local tester = torch.Tester()

local TestQLin = {}
function TestQLin.test_add_once()
    local mdp = Easy21()
    local q = QLin()
    q.weights = torch.zeros(N_FEATURES)
    local d_weights = torch.zeros(N_FEATURES)
    d_weights[1] = 1
    q:add(d_weights)

    local a = 1
    local expected = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES, N_ACTIONS)
    for dealer = 1, 4 do
        for player = 1, 6 do
            local s = {dealer, player}
            expected[s][a] = 1
        end
    end

    local s = {2, 3}
    tester:asserteq(q:get_value(s, a), 1)
    tester:assertTensorEq(
        q:get_q_tensor(),
        expected,
        0)
    tester:asserteq(q:get_best_action(s), 1)
end

tester:add(TestQLin)

tester:run()
