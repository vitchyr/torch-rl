local eval = require 'evaluation'
require 'Sarsa'

math.randomseed(os.time())

local cmd = torch.CmdLine()
cmd:option('-ni', 3, 'log_10(# of iterations)')
local params = cmd:parse(arg)

local num_iters = 10^params.ni
for lambda = 0, 1, 0.1 do
    eval.displayMetrics(
        sarsa.get_sarsa_policy(num_iters, lambda),
        'SARSA, lambda = ' .. lambda.. ', # iters = ' .. num_iters)
end
