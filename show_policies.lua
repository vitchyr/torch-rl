require 'constants'
local aa = require 'algoanalyzer'
local qva = require 'qvanalyzer'
require 'Sarsa'
require 'LinSarsa'
local gnuplot = require 'gnuplot'

local cmd = torch.CmdLine()
cmd:option('-nmci', 3, 'log_10(# of iterations for Monte Carlo)')
cmd:option('-ni', 3, 'log_10(# of iterations for Sarsa & Lin Approx)')
cmd:option('-loadqfrom', '', 'load monte carlo Q from this file if provided')
local params = cmd:parse(arg)
local n_mc_iters = 10^params.nmci
local n_iters = 10^params.ni


print('Making action plot for MC')
local Q_mc = aa.get_true_q(params.loadqfrom, n_mc_iters)
gnuplot.figure()
qva.plot_action(Q_mc, "Truth")

for lambda = 0, 1 do
    print('Making action plot for Sarsa, lambda = ' .. lambda ..
          ', # iterations = ' .. n_iters)
    local Q_td = sarsa.get_sarsa_policy_params(n_iters, lambda)
    gnuplot.figure()
    qva.plot_action(Q_td, "Sarsa, lambda="..lambda..", # iters="..n_iters)

    print('Making action plot for Lin Approx Sarsa, lambda = ' .. lambda ..
          ', # iterations = ' .. n_iters)
    local Q_la = la.get_policy_params(n_iters, lambda)
    gnuplot.figure()
    qva.plot_action(Q_la, "Lin Approx, lambda="..lambda..", # iters="..n_iters)
end
