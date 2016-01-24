require 'rl'
local tester = torch.Tester()

local TestTestMdpQVAnalyzer = {}
local qva = rl.TestMdpQVAnalyzer()

local v = {} -- mock VFunc
function v:get_value(state)
    return state
end

local q = {} -- mock QFunc
function q:get_value(state, action)
    return state + action
end

function q:get_best_action(state)
    return 3
end

function TestTestMdpQVAnalyzer.test_get_v_tensor()
    local expected = torch.Tensor{1, 2, 3}
    tester:assertTensorEq(expected, qva:get_v_tensor(v), 0)
end

function TestTestMdpQVAnalyzer.test_get_q_tensor()
    local expected_table = { -- row = state, col = action
        {2, 3, 4},
        {3, 4, 5},
        {4, 5, 6},
    }
    local expected = torch.Tensor(expected_table)
    tester:assertTensorEq(expected, qva:get_q_tensor(q), 0)
end

function TestTestMdpQVAnalyzer.test_v_from_q()
    local expected_v = {}
    function expected_v:get_value(state)
        return state + 3
    end

    local result_v = qva:v_from_q(q)

    tester:assert(result_v:__eq(expected_v))
end

tester:add(TestTestMdpQVAnalyzer)

tester:run()

