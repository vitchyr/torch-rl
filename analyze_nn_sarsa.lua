-- Analyze how NNSarsa does on BlackJack
require 'NNSarsaFactory'
require 'BlackJackOneHotSAFE'
require 'ConstExplorer'
require 'constants'
local as = require 'analyze_sarsa'

local fe = BlackJackOneHotSAFE()
local explorer = ConstExplorer(EPS)
local factory = NNSarsaFactory(nil, nil, explorer, fe, STEP_SIZE)
factory:set_feature_extractor(fe)
as.analyze_sarsa(factory, 'q5')
