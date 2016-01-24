require 'rl'
local tester = torch.Tester()

local TestTestMdp = {}
function TestTestMdp.test_terminates()
    local mdp = rl.TestMdp()
    local s = mdp:get_start_state()
    s = mdp:step(s, 1)
    s = mdp:step(s, 1)
    tester:assert(mdp:is_terminal(s))
end

function TestTestMdp.test_reward()
    local mdp = rl.TestMdp()
    local old_s = 1
    local a = 1
    local new_s, r = mdp:step(old_s, a)
    tester:asserteq(r, -1)

    a = 3
    local _, r = mdp:step(new_s, a)
    tester:asserteq(r, 1)
end

tester:add(TestTestMdp)

tester:run()

