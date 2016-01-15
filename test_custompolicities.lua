local easy21 = require 'easy21'
require 'evaluation'
require 'Agent'

local cp = require 'custompolicies'

math.randomseed(os.time())

local a = Agent(easy21)
local e = Evaluator(a)
for t = -1, 22 do
    e:displayMetrics(ThresholdPolicy(t), 'thresh, t = ' .. t)
end
e:displayMetrics(cp.always_hit, 'always hit')
e:displayMetrics(cp.always_stick, 'always stick')
