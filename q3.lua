-- Implement Q3 of the Easy 21 assignment
require 'TableSarsa'
require 'LinSarsaFactory'
require 'Easy21BoxSAFE'
require 'constants'
local as = require 'analyze_sarsa'

local fe = Easy21BoxSAFE()
local factory = LinSarsaFactory(EPS, fe)
as.analyze_sarsa(factory, 'q3')
