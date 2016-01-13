local QHash = require 'qhash'
local VHash = require 'vhash'
local qva = require 'qvanalyzer'
local qlin = require 'qlin'

local tester = torch.Tester()

local TestQHash = {} --class
    function TestQHash.test_add_once()
        local q = QHash:new()
        local s = {1, 1}
        local a = 1
        q:add(s, a, 1)

        local expected = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES, N_ACTIONS)
        expected[s][a] = 1

        tester:asserteq(q:get_value(s, a), 1)
        tester:assertTensorEq(
            q:get_q_tensor(),
            expected,
            0)
        tester:asserteq(q:get_best_action(s), 1)
    end
    function TestQHash.test_mult()
        local q = QHash:new()
        local s = {1, 1}
        local a = 1
        q:add(s, a, 1)
        q:mult(s, a, 3)
        q:mult(s, a, 3)
        q:mult(s, a, 3)

        tester:asserteq(q:get_value(s, a), 27)
    end
    function TestQHash.test_add_many()
        local q = QHash:new()
        local expected = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES, N_ACTIONS)

        -- Add a bunch
        local s = {1, 1}
        local a = 1
        q:add(s, a, 1)
        q:add(s, a, 1)
        q:add(s, a, 1)
        q:add(s, a, 1)
        q:add(s, a, 1)
        expected[s][a] =  5
        a = 2
        q:add(s, a, 6)
        expected[s][a] =  6

        tester:asserteq(q:get_value(s, 1), 5)
        tester:asserteq(q:get_value(s, 2), 6)
        tester:assertTensorEq(
            q:get_q_tensor(),
            expected,
            0)
        tester:asserteq(q:get_best_action(s), 2)

        -- Add some more
        s = {6, 21}
        a = 1
        q:add(s, a, 1)
        q:add(s, a, 0.5)
        q:add(s, a, 1)
        expected[s][a] =  2.5
        a = 2
        q:add(s, a, 2)
        expected[s][a] =  2

        tester:asserteq(q:get_value(s, 1), 2.5)
        tester:asserteq(q:get_value(s, 2), 2)
        tester:assertTensorEq(
            q:get_q_tensor(),
            expected,
            0)
        tester:asserteq(q:get_best_action(s), 1)

        -- Subtract some
        a = 1
        q:add(s, a, -1)
        expected[s][a] =  1.5

        tester:asserteq(q:get_value(s, 1), 1.5)
        tester:assertTensorEq(
            q:get_q_tensor(),
            expected,
            0)
        tester:asserteq(q:get_best_action(s), 2)
    end
-- class TestQHash
local TestVHash = {} --class
    function TestVHash.test_add_once()
        local v = VHash:new()
        local s = {1, 1}
        v:add(s, 1)
        tester:asserteq(v:get_value(s), 1)
    end
    function TestVHash.test_mult()
        local v = VHash:new()
        local s = {1, 1}
        v:add(s, 1)
        v:mult(s, 1)
        v:mult(s, 2)
        v:mult(s, 4)
        tester:asserteq(v:get_value(s), 8)
    end
    function TestVHash.test_add_many()
        local v = VHash:new()

        -- Add a bunch
        local s = {1, 1}
        v:add(s, 1)
        v:add(s, 1)
        v:add(s, 1)
        v:add(s, 1)
        v:add(s, 1)
        tester:asserteq(v:get_value(s), 5)

        -- Add some more
        s = {6, 21}
        v:add(s, 1)
        v:add(s, 0.5)
        v:add(s, 1)
        v:add(s, 2)
        tester:asserteq(v:get_value(s), 4.5)

        -- Subtract some
        v:add(s, -1)
        tester:asserteq(v:get_value(s), 3.5)
    end
-- class TestVHash

TestQVAnalyzer = {} -- class
    function TestQVAnalyzer.test_v_from_q()
        local q = QHash:new()
        local v = VHash:new()
        local s = {1, 1}
        local a = 1
        q:add(s, a, 1)
        v:add(s, 1)

        s = {2, 1}
        q:add(s, a, 14)
        v:add(s, 14)

        s = {2, 2}
        q:add(s, a, -1)
        v:add(s, 0)

        s = {2, 20}
        q:add(s, a, 0)
        v:add(s, 0)

        local v2 = qva.v_from_q(q)
        tester:assertTensorEq(v:get_v_tensor(), v2:get_v_tensor(), 0)
    end

    function TestQVAnalyzer.test_q_rms()
        local q1 = QHash:new()
        local q2 = QHash:new()
        local s = {1, 1}
        local a = 1

        q1:add(s, a, 1)
        q2:add(s, a, 1)

        s = {2, 5}
        a = 2
        q1:add(s, a, 1)
        q2:add(s, a, 2)

        s = {1, 5}
        a = 2
        q1:add(s, a, 2)
        q2:add(s, a, 4)

        tester:asserteq(qva.q_rms(q1, q2), 5)
    end
-- class TestQVAnalyzer

TestQLin = {} -- class
    function TestQLin:test_add_once()
        local q = qlin.QLin:new()
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
    function TestQLin:test_add_many()
        local q = qlin.QLin:new()
        q.weights = torch.zeros(N_FEATURES)
        local d_weights = torch.zeros(N_FEATURES)
        d_weights[2] = 1 -- dealer = [1, 4], player = [1, 6], action = 2
        q:add(d_weights)

        d_weights = torch.zeros(N_FEATURES)
        d_weights[35] = 1 -- dealer = [7, 10], player = [16, 21], action = 1
        d_weights[4] = 1 -- dealer = [1, 4], player = [4, 9], action = 2
        q:add(d_weights)

        local expected = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES, N_ACTIONS)

        local a = 2
        for dealer = 1, 4 do
            for player = 1, 6 do
                local s = {dealer, player}
                expected[s][a] = 1 + expected[s][a]
            end
        end

        a = 1
        for dealer = 7, 10 do
            for player = 16, 21 do
                local s = {dealer, player}
                expected[s][a] = 1 + expected[s][a]
            end
        end

        a = 2
        for dealer = 1, 4 do
            for player = 4, 9 do
                local s = {dealer, player}
                expected[s][a] = 1 + expected[s][a]
            end
        end

        local s = {3, 5}
        -- Should equal 2 b/c this state triggers two features
        tester:asserteq(q:get_value(s, a), 2)
        tester:assertTensorEq(
            q:get_q_tensor(),
            expected,
            0)
        -- Should equal 2 b/c we chose the actions to be 2 for these states
        tester:asserteq(q:get_best_action(s), 2, 'get_best_action not working')
    end
    function TestQLin:test_mult_once()
        local q = qlin.QLin:new()
        q.weights = torch.zeros(N_FEATURES)
        local d_weights = torch.zeros(N_FEATURES)
        d_weights[1] = 1
        q:add(d_weights)

        local a = 1
        local expected = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES, N_ACTIONS)
        for dealer = 1, 4 do
            for player = 1, 6 do
                local s = {dealer, player}
                expected[s][a] = 0.5
            end
        end

        q:mult(0.5)
        local s = {2, 3}
        tester:asserteq(q:get_value(s, a), 0.5)
        tester:assertTensorEq(
            q:get_q_tensor(),
            expected,
            0)
        tester:asserteq(q:get_best_action(s), 1)
    end
    function TestQLin:test_get_weight_vector()
        local q = qlin.QLin:new()
        q.weights = torch.zeros(N_FEATURES)
        local d_weights = torch.zeros(N_FEATURES)
        d_weights[1] = 1
        q:add(d_weights)

        local a = 1
        local expected = torch.zeros(N_FEATURES)
        expected[1] = 0.5

        q:mult(0.5)
        tester:assertTensorEq(
            q:get_weight_vector(),
            expected,
            0)
    end
-- class TestQLin

tester:add(TestQHash)
tester:add(TestVHash)
tester:add(TestQVAnalyzer)
tester:add(TestQLin)

return tester
