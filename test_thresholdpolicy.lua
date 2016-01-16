local easy21 = require 'easy21'
require 'evaluation'
require 'Agent'

local tp = require 'ThresholdPolicy'

math.randomseed(os.time())

local a = Agent(easy21)
local e = Evaluator(a)
for t = -1, 22 do
    e:display_metrics(ThresholdPolicy(t), 'thresh, t = ' .. t)
end
e:display_metrics(tp.always_hit, 'always hit')
e:display_metrics(tp.always_stick, 'always stick')
