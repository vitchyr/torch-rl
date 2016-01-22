-- Analyze how TableSarsa does on BlackJack
require 'TableSarsaFactory'
require 'BlackJackBoxSAFE'
require 'constants'
local as = require 'analyze_sarsa'

local factory = TableSarsaFactory()
as.analyze_sarsa(factory, 'q3')
