-- Implement Q3 of the Easy 21 assignment
require 'TableSarsaFactory'
require 'Easy21BoxSAFE'
require 'constants'
local as = require 'analyze_sarsa'

local factory = TableSarsaFactory()
as.analyze_sarsa(factory, 'q3')
