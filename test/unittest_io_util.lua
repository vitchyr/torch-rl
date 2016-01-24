require 'rl'

local tester = torch.Tester()

local TestIOUtil = {}
function TestIOUtil.test_save_load()
    local q = rl.rl.QHash(rl.TestMdp())
    rl.util.save_q('/tmp/q', q)
    local q2 = rl.util.load_q('/tmp/q')
    tester:asserteq(q, q2)
end
tester:add(TestIOUtil)

tester:run()
