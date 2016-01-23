-- Analyze how LinSarsa does on BlackJack
require 'rl'
require 'BlackJackBoxSAFE'
require 'constants'
local as = require 'analyze_sarsa'

local fe = BlackJackBoxSAFE()
local explorer = rl.ConstExplorer(EPS)
local factory = rl.LinSarsaFactory(nil, nil, explorer, fe, STEP_SIZE)
factory:set_feature_extractor(fe)
as.analyze_sarsa(factory, 'lin_sarsa')
