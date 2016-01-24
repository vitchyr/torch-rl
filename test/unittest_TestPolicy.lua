require 'rl'
local tester = torch.Tester()

local TestTestPolicy = {}
function TestTestPolicy.test_correct_action()
    local a = 2
    local policy = rl.TestPolicy(a)
    tester:asserteq(a, policy:get_action(3))
end

tester:add(TestTestPolicy)

tester:run()

