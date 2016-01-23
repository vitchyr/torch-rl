require 'rl'
require 'TestSAFE'
require 'MdpConfig'
require 'ConstExplorer'
local tester = torch.Tester()

local mdp = rl.TestMdp()
local discount_factor = 0.631
local TestLinSarsaFactory = {}
function TestLinSarsaFactory.test_get_control()
    local mdp_config = MdpConfig(mdp, discount_factor)
    local lambda = 0.65
    local eps = 0.2437
    local explorer = ConstExplorer(eps)
    local feature_extractor = TestSAFE()
    local step_size = 0.92

    local lin_sarsa = rl.LinSarsa(
        mdp_config,
        lambda,
        explorer,
        feature_extractor,
        step_size)
    local factory = rl.LinSarsaFactory(
        mdp_config,
        lambda,
        explorer,
        feature_extractor,
        step_size)
    tester:assert(factory:get_control() == lin_sarsa)
end

tester:add(TestLinSarsaFactory)

tester:run()

