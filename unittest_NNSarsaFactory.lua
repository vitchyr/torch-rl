require 'NNSarsaFactory'
require 'NNSarsa'
require 'TestMdp'
require 'TestSAFE'
require 'MdpConfig'
local tester = torch.Tester()

local mdp = TestMdp()
local discount_factor = 0.631
local TestNNSarsaFactory = {}
function TestNNSarsaFactory.test_get_control()
    local mdp_config = MdpConfig(mdp, discount_factor)
    local lambda = 0.65
    local eps = 0.2437
    local feature_extractor = TestSAFE()
    local step_size = 0.92

    local lin_sarsa = NNSarsa(mdp_config, lambda, eps, feature_extractor, step_size)
    local factory = NNSarsaFactory(mdp_config, lambda, eps, feature_extractor, step_size)
    tester:assert(factory:get_control() == lin_sarsa)
end

tester:add(TestNNSarsaFactory)

tester:run()

