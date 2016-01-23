-- Analyze how NNSarsa does on BlackJack
require 'rl'
require 'BlackJackOneHotSAFE'
require 'constants'
local as = require 'analyze_sarsa'

local fe = BlackJackOneHotSAFE()
local explorer = rl.ConstExplorer(EPS)
local factory = rl.NNSarsaFactory(nil, nil, explorer, fe, STEP_SIZE)
factory:set_feature_extractor(fe)
as.analyze_sarsa(factory, 'nn_sarsa')
