-- Implement Q4 of the Easy 21 assignment
require 'SarsaAnalyzer'
require 'LinSarsa'
require 'MdpConfig'
require 'Easy21'
require 'Easy21QVAnalyzer'

math.randomseed(os.time())
local cmd = torch.CmdLine()
cmd:option('-loadqfrom', '', 'load monte carlo Q from this file if provided')
cmd:option('-nosave', false, 'save plots')
cmd:option('-show', false, 'show plots')
cmd:option('-n_iters', N_ITERS, '# of iterations for evaluation')
cmd:option('-rms_plot_freq', N_ITERS/100, '# of iterations per data point for RMS plot')
local opt = cmd:parse(arg)
opt.save = not opt.nosave

local discount_factor = 1
local mdp_config = MdpConfig(Easy21(), discount_factor)
local qvanalyzer = Easy21QVAnalyzer()
local analyzer = SarsaAnalyzer(opt, mdp_config, qvanalyzer, LinSarsa)

analyzer:eval_lambdas(
    'q4a.eps')
analyzer:eval_l0_l1_rms(
    'q4b.eps')
