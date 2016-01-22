require 'rl'
require 'SarsaAnalyzer'
require 'MdpConfig'
require 'BlackJack'
require 'BlackJackQVAnalyzer'

math.randomseed(os.time())
local cmd = torch.CmdLine()
cmd:option('-loadqfrom', '', 'load monte carlo Q from this file if provided')
cmd:option('-nosave', false, 'save plots')
cmd:option('-show', false, 'show plots')
cmd:option('-ni', 4, 'log_10(# of iterations)')
cmd:option('-rms_num_points', 100, '# of data point for RMS plot')
local opt = cmd:parse(arg)
opt.save = not opt.nosave
opt.n_iters = 10^opt.ni

local M = {}

function M.analyze_sarsa(sarsa_factory, fname_base)
    local discount_factor = 1
    local mdp_config = MdpConfig(BlackJack(), discount_factor)
    local qvanalyzer = BlackJackQVAnalyzer()
    sarsa_factory:set_mdp_config(mdp_config)
    local analyzer = SarsaAnalyzer(opt, mdp_config, qvanalyzer, sarsa_factory)

    analyzer:eval_lambdas(fname_base .. '_rms_vs_lambda.eps')
    analyzer:eval_l0_l1_rms(fname_base .. '_rms_vs_iteration.eps')
end

return M
