require 'VHash'
require 'TestMdp'

local tester = torch.Tester()
local TestVHash = {}

function TestVHash.test_add_once()
    local q = VHash(TestMdp())
    local s = 1
    local val = 2
    q:add(s, val)

    tester:asserteq(q:get_value(s), val)
end

function TestVHash.test_mult()
    local q = VHash(TestMdp())
    local s = 2
    q:add(s, 1)
    q:mult(s, 3)
    q:mult(s, 3)
    q:mult(s, 3)

    tester:asserteq(q:get_value(s), 27)
end

tester:add(TestVHash)

tester:run()
