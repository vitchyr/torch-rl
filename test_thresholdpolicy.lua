require 'rl'
require 'BlackJack'

local tp = require 'ThresholdPolicy'

math.randomseed(os.time())

local config = rl.MdpConfig(BlackJack(), 1)
local e = rl.Evaluator(config)
for t = -1, 22 do
    e:display_metrics(ThresholdPolicy(t), 'thresh, t = ' .. t)
end
e:display_metrics(tp.always_hit, 'always hit')
e:display_metrics(tp.always_stick, 'always stick')
