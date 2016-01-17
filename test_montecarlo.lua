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

local function test_montecarlo_for_env(env)
    local e = Evaluator(env)

    local init_policy = AllActionsEqualPolicy(env)
    local mc = MonteCarloControl(env, init_policy)
    for n = params.min, params.max do
        local n_iters = 10^n
        mc:set_policy(init_policy)
        mc:improve_policy_for_n_iters(n_iters)
        local policy = mc:get_policy()

        e:display_metrics(policy, 'MC, # iters = ' .. n_iters)
    end
end

test_montecarlo_for_env(Easy21())
test_montecarlo_for_env(TestMdp())
