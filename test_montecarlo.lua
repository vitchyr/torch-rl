require 'rl'
require 'BlackJack'
require 'Evaluator'
require 'MdpConfig'

math.randomseed(os.time())

local cmd = torch.CmdLine()
cmd:option('-min', 1,'minimum log_10(# iterations)')
cmd:option('-max', 5,'minimum log_10(# iterations)')
local params = cmd:parse(arg)

local discount_factor = 1

local function test_montecarlo_for_mdp(mdp)
    local mdp_config = MdpConfig(mdp, discount_factor)
    local e = Evaluator(mdp_config)

    for n = params.min, params.max do
        local n_iters = 10^n
        local mc = rl.MonteCarloControl(mdp_config)
        mc:improve_policy_for_n_iters(n_iters)
        local policy = mc:get_policy()

        e:display_metrics(policy, 'MC, # iters = ' .. n_iters)
    end
end

test_montecarlo_for_mdp(BlackJack())
test_montecarlo_for_mdp(rl.TestMdp())
