-- Analyze how TableSarsa does on BlackJack
require 'rl'
require 'BlackJackBoxSAFE'
require 'constants'
local as = require 'analyze_sarsa'

local factory = rl.TableSarsaFactory()
as.analyze_sarsa(factory, 'table_sarsa')
