require 'LinSarsa'
require 'MdpConfig'
require 'TestMdp'
local ufu = require 'util_for_unittests'
local tester = torch.Tester()

local discount_factor = 0.95
local mdp = TestMdp()
local mdp_config = MdpConfig(mdp, discount_factor)

local TestLinSarsa = {}

function TestLinSarsa.test_update_eligibility_one_step()
    local lambda = 1
    local sarsa = TableSarsa(mdp_config, lambda)

    local s = 2
    local a = 1
    sarsa:update_eligibility(s, a)
    local eligibility_expected = { -- row = state, colm = action
        [1] = {0, 1, 0},
        [2] = {1, 0, 1},
        [3] = {0, 1, 0}
    }
    tester:assert(ufu.do_qtable_qfunc_match(
        mdp,
        eligibility_expected,
        sarsa.eligibility))
end

tester:add(TestLinSarsa)

tester:run()

