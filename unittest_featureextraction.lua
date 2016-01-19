local fe = require 'featureextraction'

local tester = torch.Tester()

local TestFeatureExtraction = {} --class
    function TestFeatureExtraction.test_onehot_fe()
        local s = {1, 2}
        local a = {1}
        local f = fe.get_features(s, a)
        local expected = torch.zeros(36)
        expected[1] = 1

        tester:assertTensorEq(f, expected, 0)
    end

    function TestFeatureExtraction.test_manyhot_fe()
        local s = {4, 5}
        local a = {1}
        local f = fe.get_features(s, a)
        local expected = torch.zeros(36)
        expected[1] = 1
        expected[3] = 1
        expected[13] = 1
        expected[15] = 1

        tester:assertTensorEq(f, expected, 0)
    end
-- class TestFeatureExtraction

tester:add(TestFeatureExtraction)
tester:run()
