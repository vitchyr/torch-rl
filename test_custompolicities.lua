local eval = require 'evaluation'
local mdp = require 'mdp'
local easy21 = require 'easy21'

local cp = require 'custompolicies'

math.randomseed(os.time())

local m = mdp.MDP(easy21)
local e = eval.Evaluator(m)
for t = -1, 22 do
    e:displayMetrics(cp.get_threshold_policy(t), 'thresh, t = ' .. t)
end
e:displayMetrics(cp.always_hit, 'always hit')
e:displayMetrics(cp.always_stick, 'always stick')
e:displayMetrics(cp.always_stick, 'always stick')
