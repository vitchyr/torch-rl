-- Implement Q3 of the Easy 21 assignment
require 'TableSarsaFactory'
require 'BlackJackBoxSAFE'
require 'constants'
local as = require 'analyze_sarsa'

local factory = TableSarsaFactory()
as.analyze_sarsa(factory, 'q3')
