require 'constants'
local mdp = require 'mdp'
local cp = require 'custompolicies'

local tester = torch.Tester()

local TestMDP = {} --class
    function TestMDP.test_alwayshit()
        local episode = mdp.get_episode(cp.always_hit)
        local data = episode[1]
        local expected_Gt = -1
        for t, data in pairs(episode) do
            local s, a, Gt = table.unpack(data)
            tester:asserteq(a, HIT)
            tester:asserteq(Gt, expected_Gt)
        end
    end
    function TestMDP.test_alwaysstick()
        local episode = mdp.get_episode(cp.always_stick)
        local data = episode[1]
        local _, _, expected_Gt = table.unpack(data)
        for t, data in pairs(episode) do
            local s, a, Gt = table.unpack(data)
            tester:asserteq(a, STICK)
            -- Gt should be same for all actions since GAMMA = 1
            if GAMMA == 1 then
                tester:asserteq(Gt, expected_Gt)
            end
        end
    end
    function TestMDP.test_thresh()
        for threshold = -1, 22 do
            local episode = mdp.get_episode(cp.get_threshold_policy(threshold))
            local data = episode[1]
            local _, _, expected_Gt = table.unpack(data)
            for t, data in pairs(episode) do
                local s, a, Gt = table.unpack(data)
                local dealer, player = table.unpack(s)
                if player < threshold then
                    tester:asserteq(a, HIT)
                else
                    tester:asserteq(a, STICK)
                end
                -- Gt should be same for all actions since GAMMA = 1
                if GAMMA == 1 then
                    tester:asserteq(Gt, expected_Gt)
                end
            end
        end
    end
-- class TestMDP

tester:add(TestMDP)

return tester
