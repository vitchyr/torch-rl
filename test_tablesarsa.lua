require 'rl'
require 'BlackJack'
require 'TestMdp'
require 'MdpConfig'
require 'Evaluator'

math.randomseed(os.time())

local cmd = torch.CmdLine()
cmd:option('-ni', 3, 'log_10(# of iterations)')
local params = cmd:parse(arg)

local n_iters = 10^params.ni
local discount_factor = 1

local function test_sarsa_diff_lambda(mdp)
    local mdp_config = MdpConfig(mdp, discount_factor)
    local e = Evaluator(mdp_config)

    for lambda = 0, 1, 0.1 do
        local control = rl.TableSarsa(mdp_config, lambda)
        control:improve_policy_for_n_iters(n_iters)

        local policy = control:get_policy()
        e:display_metrics(policy, 'Sarsa, # iters = ' .. n_iters ..
                          ', lambda = ' .. lambda)
    end
end
test_sarsa_diff_lambda(BlackJack())
test_sarsa_diff_lambda(TestMdp())
