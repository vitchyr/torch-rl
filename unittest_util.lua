local util = require 'util'

local tester = torch.Tester()

local TestUtil = {}
function TestUtil.test_get_count()
    local list = {1, 1, 1, 2}
    tester:asserteq(util.get_count(1, list), 3)
end

function TestUtil.test_is_prob_good_good()
    local n = 5
    local p = 0.5
    local N = 10
    tester:assert(util.is_prob_good(n, p, N))
    tester:assert(util.is_prob_good(0, 0, N))
end

function TestUtil.test_is_prob_good_bad()
    local n = 1
    local p = 0.5
    local N = 100
    tester:assert(not util.is_prob_good(n, p, N))
    tester:assert(not util.is_prob_good(1, 0, N))
end

function TestUtil.test_elem_has_good_freq()
    local list = {1, 1, 1, 2}
    tester:assert(util.elem_has_good_freq(1, list, 0.75))
    tester:assert(util.elem_has_good_freq(2, list, 0.25))
    tester:assert(util.elem_has_good_freq(3, list, 0))
    tester:assert(not util.elem_has_good_freq(2, list, 0))
end

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

function TestUtil.test_weighted_random_choice_only_one()
    local t = {
        a = 0,
        b = 0,
        c = 0,
        d = 1
    }
    local function choice_is_always_good()
        for i = 1, 100 do
            if util.weighted_random_choice(t) ~= 'd' then
                return false
            end
        end
        return true
    end
    tester:assert(choice_is_always_good())
end

function TestUtil.test_weighted_random_choice()
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
    local N = 100000
    local denom = util.sum(t)
    local nums = torch.zeros(8)
    for i = 1, N do
        result = util.weighted_random_choice(t)
        nums[result] = nums[result] + 1
    end
    local function prob_is_good()
        for i = 1, nums:numel() do
            if not util.is_prob_good(nums[i], t[i] / denom, N) then
                return false
            end
        end
        return true
    end
    tester:assert(prob_is_good())
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

function TestUtil.test_deepcompare()
    local t1 = {
        a = 1,
        b = {x=4, y=3, z=1},
        c = {1, 2, 3},
        d = -6
    }
    local t2 = {
        b = {x=4, y=3, z=1},
        a = 1,
        d = -6,
        c = {1, 2, 3}
    }
    tester:assert(util.deepcompare(t1, t2))
end

function TestUtil.test_deepcompare_int_keys()
    local t1 = {
        [4] = 1,
        [-3] = 2,
        [0] = {1, 2, 3},
        [1] = -6
    }
    local t2 = {
        [-3] = 2,
        [4] = 1,
        [1] = -6,
        [0] = {1, 2, 3}
    }
    tester:assert(util.deepcompare(t1, t2))
end

function TestUtil.test_deepcompare_with_meta()
    local t1 = {
        a = 1,
        b = {x=4, y=3, z=1},
        c = {1, 2, 3},
        d = -6
    }
    local t2 = {
        b = {x=4, y=3, z=1},
        a = 1,
        d = -6,
        c = {1, 2, 3}
    }
    local mt = {
      __eq = function (lhs, rhs)
        return true
      end
    }
    setmetatable(t1, mt)
    setmetatable(t2, mt)
    tester:assert(util.deepcompare_with_meta(t1, t2))
end

function TestUtil.test_deepcompare_with_meta_false()
    local t1 = {
        a = 1,
        b = {x=4, y=3, z=1},
        c = {1, 2, 3},
        d = -6
    }
    local t2 = {
        b = {x=4, y=3, z=1},
        a = 1,
        d = -6,
        c = {1, 2, 3}
    }
    local mt = {
      __eq = function (lhs, rhs)
        return false
      end
    }
    setmetatable(t1, mt)
    setmetatable(t2, mt)

    tester:assert(not util.deepcompare_with_meta(t1, t2))
end

tester:add(TestUtil)

tester:run()
