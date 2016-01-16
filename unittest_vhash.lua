require 'VHash'

local tester = torch.Tester()
local TestVHash = {}

local env = {}
function env.hash_s(s)
    local a, b = unpack(s)
    return a + b
end
function env.get_all_states()
    return {{1, 1}, {1, 2}}
end

function TestVHash.test_add_once()
    local q = VHash(env)
    local s = {1, 1}
    local val = 2
    q:add(s, val)

    tester:asserteq(q:get_value(s), val)
end

function TestVHash.test_mult()
    local q = VHash(env)
    local s = {1, 2}
    q:add(s, 1)
    q:mult(s, 3)
    q:mult(s, 3)
    q:mult(s, 3)

    tester:asserteq(q:get_value(s), 27)
end

tester:add(TestVHash)

return tester
