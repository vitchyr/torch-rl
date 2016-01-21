-- Implement Q4 of the Easy 21 assignment but for neural network approximation
require 'LinSarsaFactory'
require 'Easy21OneHotSAFE'
require 'ConstExplorer'
require 'constants'
local as = require 'analyze_sarsa'

local fe = Easy21OneHotSAFE()
local explorer = ConstExplorer(EPS)
local factory = NNSarsaFactory(nil, nil, explorer, fe, STEP_SIZE)
factory:set_feature_extractor(fe)
as.analyze_sarsa(factory, 'q5')
