require 'BlackJack'
require 'BlackJackQVAnalyzer'
require 'TestMdpQVAnalyzer'
local plot = require 'gnuplot'

math.randomseed(os.time())
local cmd = torch.CmdLine()
cmd:option('-ni', 4, 'log_10(# of iterations)')
cmd:option('-saveqto', '', 'save Q to this file if provided')
cmd:option('-nosave', false, 'do not save plots')
cmd:option('-show', false, 'show plots')
local params = cmd:parse(arg)

local n_iters = 10^params.ni
local discount_factor = 1

local function show_mc_plots(mdp, analyzer)
    local mdp_config = rl.MdpConfig(mdp, discount_factor)
    local mc = rl.MonteCarloControl(mdp_config)
    mc:improve_policy_for_n_iters(n_iters)

    local q = mc:get_q()
    local v = analyzer:v_from_q(q)

    if params.show then
        gnuplot.figure()
        analyzer:plot_v(v)
        gnuplot.figure()
        analyzer:plot_best_action(q)
    end
    if not params.nosave then
        gnuplot.epsfigure('q2a.eps')
        analyzer:plot_v(v)
        gnuplot.epsfigure('q2b.eps')
        analyzer:plot_best_action(q)
        gnuplot.plotflush()
    end

    if params.saveqto ~= '' then
        torch.save(params.saveqto, {q, q.__index})
    end
end

show_mc_plots(rl.TestMdp(), TestMdpQVAnalyzer())
show_mc_plots(BlackJack(), BlackJackQVAnalyzer())
