require 'QHash'

local tester = torch.Tester()
local TestQHash = {}

local env = {}
function env.hash_s(s)
    a, b = unpack(s)
    return a + b
end
function env.hash_a(a)
    return a
end
function env.get_all_states()
    return {{1, 1}, {1, 2}}
end
function env.get_all_actions()
    return {1, 2, 3}
end

function TestQHash.test_add_once()
    local q = QHash(env)
    local s = {1, 1}
    local a = 1
    local val = 2
    q:add(s, a, val)

    tester:asserteq(q:get_value(s, a), val)
    tester:asserteq(q:get_best_action(s), a)
end

function TestQHash.test_mult()
    local q = QHash(env)
    local s = {1, 2}
    local a = 3
    q:add(s, a, 1)
    q:mult(s, a, 3)
    q:mult(s, a, 3)
    q:mult(s, a, 3)

    tester:asserteq(q:get_value(s, a), 27)
end

tester:add(TestQHash)

return tester
