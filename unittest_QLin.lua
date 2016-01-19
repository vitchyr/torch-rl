require 'QLin'
require 'TestSAFE'
require 'TestMdp'
require 'TestMdpQVAnalyzer'
local tester = torch.Tester()

local TestQLin = {}

local mdp = TestMdp()
local function get_expected_q_tensor()
    local expected_q_tensor = torch.zeros(
        #(mdp:get_all_actions()),
        #(mdp:get_all_actions()))
    for s = 1, #mdp:get_all_states() do
        for a = 1, #(mdp:get_all_actions()) do
            expected_q_tensor[s][a] = s+a
        end
    end

    return expected_q_tensor
end
function TestQLin.test_add_once()
    local fe = TestSAFE()

    local q = QLin(mdp, fe)
    local feature_dim = fe:get_sa_features_dim()
    q.weights = torch.zeros(feature_dim)
    local d_weights = torch.zeros(feature_dim)
    d_weights[1] = 1
    q:add(d_weights)

    local s = 1
    local a = 1
    tester:asserteq(q:get_value(s, a), 2, "Wrong state-action value.")
    tester:asserteq(q:get_best_action(s), 3, "Wrong best action.")

    local analyzer = TestMdpQVAnalyzer()
    local expected_q_tensor = get_expected_q_tensor()
    tester:assertTensorEq(
        analyzer:get_q_tensor(q),
        expected_q_tensor,
        0)
end

tester:add(TestQLin)

tester:run()
