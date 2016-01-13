local util = require 'util'
local tensorutil = require 'tensorutil'

local tester = torch.Tester()

local TestUtil = {} --class
    function TestUtil.test_fold()
        local t = {
            1,
            1,
            1,
            3,
            1,
            1,
            1,
            3
        }

        tester:asserteq(util.sum(t), 12)
        tester:asserteq(util.fold(function(a, b) return a - b end)(0)(t), -12)
        tester:asserteq(util.fold(function(a, b) return a - b end)(-8)(t), -20)
    end

    function TestUtil.test_fold_with_key()
        local t = {
            1,
            1,
            1,
            3,
        }

        tester:asserteq(
            util.fold_with_key(function(a, k, b) return a + k + b end)(0)(t),
            16)
        tester:asserteq(
            util.fold_with_key(function(a, k, b) return a + k + b end)(-6)(t),
            10)
    end

    function TestUtil.test_weighted_random_choice()
        local t = {
            a = 0,
            b = 0,
            c = 0,
            d = 1
        }
        local result = nil
        for i = 1, 100 do
            result = util.weighted_random_choice(t)
            tester:asserteq( result, 'd' )
        end

        local N = 100000
        local function check_prob(n, p)
            local std = math.sqrt(N * p * (1-p))
            local mean = N * p
            tester:assert(mean - 4*std < n and n < mean + 4*std)
        end

        t = {
            1,
            1,
            1,
            3,
            1,
            1,
            1,
            3
        }
        local denom = util.sum(t)
        local nums = torch.zeros(8)
        for i = 1, N do
            result = util.weighted_random_choice(t)
            nums[result] = nums[result] + 1
        end
        for i = 1, nums:numel() do
            check_prob(nums[i], t[i] / denom)
        end
    end

    function TestUtil.test_max()
        local t = {
            a = 1,
            b = 2,
            c = 3,
            d = -6
        }
        local maxElem, maxK = util.max(t, function (v) return v end)
        tester:asserteq(maxElem , 3)
        tester:asserteq(maxK , 'c')

        maxElem, maxK = util.max(t, function (v) return -v end)
        tester:asserteq(maxElem , -6)
        tester:asserteq(maxK , 'd')
    end
-- class TestUtil

local TestTensorUtil = {} --class
    function TestTensorUtil.test_apply_to_slices()
        local function power_fill(tensor, i, power)
            power = power or 1
            tensor:fill(i ^ power)
        end
        local A = torch.Tensor(2, 2)
        local B = torch.Tensor(2, 2)
        B[1][1] = 1
        B[1][2] = 1
        B[2][1] = 2
        B[2][2] = 2
        tester:assertTensorEq(
            tensorutil.apply_to_slices(A, 1, power_fill),
            B,
            0)
    end

    function TestTensorUtil.fill_range()
        local A = torch.Tensor(2, 2)
        local B = torch.Tensor(2, 2)
        B[1][1] = -1
        B[1][2] = -1
        B[2][1] = 0
        B[2][2] = 0
        tester:assertTensorEq(
            tensorutil.apply_to_slices(A, 1, tensorutil.fill_range, -2),
            B,
            0)

        B[1][1] = 123
        B[2][1] = 123
        B[1][2] = 124
        B[2][2] = 124
        tester:assertTensorEq(
            tensorutil.apply_to_slices(A, 2, tensorutil.fill_range, 122),
            B,
            0)
    end
-- class TestTensorUtil

tester:add(TestUtil)
tester:add(TestTensorUtil)

return tester
