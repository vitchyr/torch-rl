local io_util = require 'io_util'
require 'QHash'
require 'TestMdp'

local tester = torch.Tester()

local TestIOUtil = {}
function TestIOUtil.test_save_load()
    local q = QHash(TestMdp())
    io_util.save_q('/tmp/q', q)
    local q2 = io_util.load_q('/tmp/q')
    tester:asserteq(q, q2)
end
tester:add(TestIOUtil)

tester:run()
