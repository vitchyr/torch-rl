require 'rl'
require 'QHash'

local tester = torch.Tester()
local TestQHash = {}

local mdp = rl.TestMdp()
function TestQHash.test_add_once()
    local q = QHash(mdp)
    local s = 1
    local a = 1
    local val = 2
    q:add(s, a, val)

    tester:asserteq(q:get_value(s, a), val)
    tester:asserteq(q:get_best_action(s), a)
end

function TestQHash.test_mult()
    local q = QHash(rl.TestMdp())
    local s = 2
    local a = 3
    q:add(s, a, 1)
    q:mult(s, a, 3)
    q:mult(s, a, 3)
    q:mult(s, a, 3)

    tester:asserteq(q:get_value(s, a), 27)
end

function TestQHash.test_equality()
    local q1 = QHash(rl.TestMdp())
    local s = 2
    local a = 3
    q1:add(s, a, 1)
    q1:mult(s, a, 3)
    q1:mult(s, a, 3)
    q1:mult(s, a, 3)

    local q2 = QHash(rl.TestMdp())
    local s = 2
    local a = 3
    q2:add(s, a, 1)
    q2:mult(s, a, 0)
    q2:add(s, a, 1)
    q2:mult(s, a, 3)
    q2:mult(s, a, 3)
    q2:mult(s, a, 3)

    tester:assert(q1 == q2)
end

tester:add(TestQHash)

tester:run()
