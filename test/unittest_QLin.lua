require 'rl'
local ufu = require 'util_for_unittests'
local tester = torch.Tester()

local TestQLin = {}

local mdp = rl.TestMdp()
function TestQLin.test_add_once()
    local fe = rl.TestSAFE()

    local q = rl.QLin(mdp, fe)
    local feature_dim = fe:get_sa_features_dim()
    q.weights = torch.zeros(feature_dim)
    local d_weights = torch.zeros(feature_dim)
    d_weights[1] = 1
    q:add(d_weights)

    local s = 1
    local a = 1
    tester:asserteq(q:get_value(s, a), 2, "Wrong state-action value.")
    tester:asserteq(q:get_best_action(s), 3, "Wrong best action.")

    local expected_q_table = { -- row = state, colm = action
        [1] = {1+1, 1+2, 1+3},
        [2] = {2+1, 2+2, 2+3},
        [3] = {3+1, 3+2, 3+3}
    }
    tester:assert(ufu.do_qtable_qfunc_match(mdp, expected_q_table, q))
end

function TestQLin.test_add_complex()
    local fe = rl.TestSAFE()

    local q = rl.QLin(mdp, fe)
    local feature_dim = fe:get_sa_features_dim()
    q.weights = torch.zeros(feature_dim)
    local d_weights = torch.zeros(feature_dim)
    local weight_1 = 3
    local weight_2 = 0.5
    d_weights[1] = weight_1
    d_weights[2] = weight_2
    q:add(d_weights)

    local s = 3
    local a = 1
    tester:asserteq(q:get_value(s, a), 12+1, "Wrong state-action value.")
    tester:asserteq(q:get_best_action(s), 3, "Wrong best action.")

    local expected_q_table = { -- row = state, colm = action
        [1] = {
            weight_1*(1+1) + weight_2*(1-1),
            weight_1*(1+2) + weight_2*(1-2),
            weight_1*(1+3) + weight_2*(1-3)
        },
        [2] = {
            weight_1*(2+1) + weight_2*(2-1),
            weight_1*(2+2) + weight_2*(2-2),
            weight_1*(2+3) + weight_2*(2-3)
        },
        [3] = {
            weight_1*(3+1) + weight_2*(3-1),
            weight_1*(3+2) + weight_2*(3-2),
            weight_1*(3+3) + weight_2*(3-3)
        }
    }
    tester:assert(ufu.do_qtable_qfunc_match(mdp, expected_q_table, q))
end

function TestQLin.test_add_and_multiply()
    local fe = rl.TestSAFE()

    local q = rl.QLin(mdp, fe)
    local feature_dim = fe:get_sa_features_dim()
    q.weights = torch.zeros(feature_dim)
    local d_weights = torch.zeros(feature_dim)
    local weight_1 = 3
    local weight_2 = 0.5
    d_weights[1] = weight_1
    d_weights[2] = weight_2
    q:add(d_weights)

    local factor = 0.9
    q:mult(factor)

    local s = 3
    local a = 1
    tester:asserteq(
        q:get_value(s, a),
        factor*(12+1),
        "Wrong state-action value.")
    tester:asserteq(q:get_best_action(s), 3, "Wrong best action.")

    local expected_q_table = { -- row = state, colm = action
        [1] = {
            factor * (weight_1*(1+1) + weight_2*(1-1)),
            factor * (weight_1*(1+2) + weight_2*(1-2)),
            factor * (weight_1*(1+3) + weight_2*(1-3))
        },
        [2] = {
            factor * (weight_1*(2+1) + weight_2*(2-1)),
            factor * (weight_1*(2+2) + weight_2*(2-2)),
            factor * (weight_1*(2+3) + weight_2*(2-3))
        },
        [3] = {
            factor * (weight_1*(3+1) + weight_2*(3-1)),
            factor * (weight_1*(3+2) + weight_2*(3-2)),
            factor * (weight_1*(3+3) + weight_2*(3-3))
        }
    }
    tester:assert(ufu.do_qtable_qfunc_match(mdp, expected_q_table, q))
end

function TestQLin.test_clear()
    local fe = rl.TestSAFE()

    local q = rl.QLin(mdp, fe)
    local feature_dim = fe:get_sa_features_dim()
    q.weights = torch.zeros(feature_dim)
    local d_weights = torch.zeros(feature_dim)
    local weight_1 = 3
    local weight_2 = 0.5
    d_weights[1] = weight_1
    d_weights[2] = weight_2
    q:add(d_weights)

    local factor = 0.9
    q:mult(factor)

    -- Now it should be the same as test_add_once
    q:clear()

    d_weights[1] = 1
    d_weights[2] = 0
    q:add(d_weights)

    local s = 1
    local a = 1
    tester:asserteq(q:get_value(s, a), 2, "Wrong state-action value.")
    tester:asserteq(q:get_best_action(s), 3, "Wrong best action.")

    local expected_q_table = { -- row = state, colm = action
        [1] = {1+1, 1+2, 1+3},
        [2] = {2+1, 2+2, 2+3},
        [3] = {3+1, 3+2, 3+3}
    }
    tester:assert(ufu.do_qtable_qfunc_match(mdp, expected_q_table, q))
end
tester:add(TestQLin)

tester:run()
