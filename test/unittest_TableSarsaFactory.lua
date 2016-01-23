require 'rl'
local tester = torch.Tester()

local mdp = rl.TestMdp()
local discount_factor = 0.12
local TestTableSarsaFactory = {}
function TestTableSarsaFactory.test_get_control()
    local mdp_config = rl.MdpConfig(mdp, discount_factor)
    local lambda = 0.126

    local table_sarsa = rl.TableSarsa(mdp_config, lambda)
    local factory = rl.TableSarsaFactory(mdp_config, lambda)
    tester:assert(factory:get_control() == table_sarsa)
end

tester:add(TestTableSarsaFactory)

tester:run()

