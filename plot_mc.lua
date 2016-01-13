local mc = require 'montecarlo'
local qva = require 'qvanalyzer'
local qlearning = require 'qlearning'
local plot = require 'gnuplot'

math.randomseed(os.time())
for n = 1, 5 do
    local n_iters = 10^n
    local Q, Ns = qlearning.get_policy_params(n_iters, mc.montecarlo_eval_policy)
    local V = qva.v_from_q(Q)
    plot.figure(n)
    qva.plot_v(V)
end
