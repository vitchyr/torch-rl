require 'rl'

local tester = torch.Tester()
local TestVHash = {}

function TestVHash.test_add_once()
    local v = rl.VHash(rl.TestMdp())
    local s = 1
    local val = 2
    v:add(s, val)

    tester:asserteq(v:get_value(s), val)
end

function TestVHash.test_mult()
    local v = rl.VHash(rl.TestMdp())
    local s = 2
    v:add(s, 1)
    v:mult(s, 3)
    v:mult(s, 3)
    v:mult(s, 3)

    tester:asserteq(v:get_value(s), 27)
end

function TestVHash.test_equality()
    local v1 = rl.VHash(rl.TestMdp())
    local s = 2
    v1:add(s, 1)
    v1:mult(s, 3)
    v1:mult(s, 3)
    v1:mult(s, 3)

    local v2 = rl.VHash(rl.TestMdp())
    local s = 2
    v2:add(s, 5)
    v2:mult(s, 0)
    v2:add(s, 2)
    v2:add(s, -1)
    v2:mult(s, 3)
    v2:mult(s, 3)
    v2:mult(s, 3)

    tester:assert(v1 == v2)
end

tester:add(TestVHash)

tester:run()
