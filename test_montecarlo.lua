require 'Easy21'
require 'TestMdp'
require 'Evaluator'
require 'MonteCarloControl'
require 'AllActionsEqualPolicy'

math.randomseed(os.time())

local cmd = torch.CmdLine()
cmd:option('-min', 1,'minimum log_10(# iterations)')
cmd:option('-max', 5,'minimum log_10(# iterations)')
local params = cmd:parse(arg)

local discount_factor = 1

local function test_montecarlo_for_mdp(mdp)
    local e = Evaluator(mdp, discount_factor)

    local init_policy = AllActionsEqualPolicy(mdp)
    local mc = MonteCarloControl(mdp, init_policy, discount_factor)
    for n = params.min, params.max do
        local n_iters = 10^n
        mc:set_policy(init_policy)
        mc:improve_policy_for_n_iters(n_iters)
        local policy = mc:get_policy()

        e:display_metrics(policy, 'MC, # iters = ' .. n_iters)
    end
end

test_montecarlo_for_mdp(Easy21())
test_montecarlo_for_mdp(TestMdp())
