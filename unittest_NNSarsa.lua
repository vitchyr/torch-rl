require 'NNSarsa'
local tester = torch.Tester()

local TestNNSarsa = {}
function TestNNSarsa.test_update_eligibility_one_step()
    -- TODO
    tester:assert(false)
end

tester:add(TestNNSarsa)

tester:run()

