require 'Easy21'
require 'AllActionsEqualPolicy'
require 'MonteCarloControl'
require 'Easy21QVAnalyzer'
local plot = require 'gnuplot'

math.randomseed(os.time())
local cmd = torch.CmdLine()
cmd:option('-ni', 6, 'log_10(# of iterations)')
cmd:option('-saveqto', '', 'save Q to this file if provided')
cmd:option('-nosave', false, 'do not save plots')
cmd:option('-show', false, 'show plots')
local params = cmd:parse(arg)

local num_iters = 10^params.ni

local function show_mc_plots(env, analyzer)
    local init_policy = AllActionsEqualPolicy(env)
    local mc = MonteCarloControl(env, init_policy)

    local q = mc:get_q()
    local v = analyzer:v_from_q(q)

    if params.show then
        gnuplot.figure()
        analyzer:plot_v(v)
        gnuplot.figure()
        analyzer:plot_action(q)
    end
    if not params.nosave then
        gnuplot.epsfigure('q2a.eps')
        analyzer:plot_v(v)
        gnuplot.epsfigure('q2b.eps')
        analyzer:plot_action(q)
        gnuplot.plotflush()
    end

    if params.saveqto ~= '' then
        torch.save(params.saveqto, {q, q.__index})
    end
end

show_mc_plots(Easy21(), Easy21QVAnalyzer())
