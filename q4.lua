-- Implement Q4 of the Easy 21 assignment
require 'LinSarsaFactory'
require 'Easy21BoxSAFE'
require 'ConstExplorer'
require 'constants'
local as = require 'analyze_sarsa'

local fe = Easy21BoxSAFE()
local explorer = ConstExplorer(EPS)
local factory = LinSarsaFactory(nil, nil, explorer, fe, STEP_SIZE)
factory:set_feature_extractor(fe)
as.analyze_sarsa(factory, 'q4')
