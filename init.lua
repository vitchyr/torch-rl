require 'torch'

include('Agent.lua')

include('Policy.lua')
include('GreedyPolicy.lua')
include('GreedyPolicy.lua')

include('Explorer.lua')
include('ConstExplorer.lua')
include('DecayTableExplorer.lua')

return rl
