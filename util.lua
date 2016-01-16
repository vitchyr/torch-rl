local M = {}

-- Thanks to
-- https://scriptinghelpers.org/questions/11242/how-to-make-a-weighted-selection
function M.weighted_random_choice(items)
    -- Sum all weights
    local total_weight = 0
    for item, weight in pairs(items) do
        total_weight = total_weight + weight
    end

    -- Pick random value
    rand = math.random() * total_weight
    choice = nil

    -- Search for the interval [0, w1] [w1, w1 + w2] [w1 + w2, w1 + w2 + w3] ...
    -- that `rand` belongs to
    -- and select the corresponding choice
    for item, weight in pairs(items) do
        if rand < weight then
            choice = item
            break
        else
            rand = rand - weight
        end
    end

    return choice
end

-- Not called fold left/right because order of pairs is not guaranteed.
function M.fold(fn)
    return function (acc)
        return function (list)
            for k, v in pairs(list) do
                acc = fn(acc, v)
            end 
            return acc 
        end
    end
end

-- Do this to avoid accumulator being reused
local sum_from = M.fold(function (a, b) return a + b end)
function M.sum(lst)
    return sum_from(0)(lst)
end

function M.fold_with_key(fn)
    return function (acc)
        return function (list)
            for k, v in pairs(list) do
                acc = fn(acc, k, v)
            end 
            return acc 
        end
    end
end

-- Return the (element with max value, key of that element) of a table
-- value_of is a function that given an element in the list, returns its value.
function M.max(tab, value_of)
    max_elem = nil
    maxK = nil
    maxV = 0
    for k, elem in pairs(tab) do
        curr_v = value_of(elem)
        if max_elem == nil or curr_v > maxV then
            max_elem = elem
            maxK = k
            maxV = curr_v
        end
    end
    return max_elem, maxK
end

-- Thanks to https://gist.github.com/tylerneylon/81333721109155b2d244
function M.copy_simply(obj)
    if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do res[M.copy_simply(k)] = M.copy_simply(v) end
    return res
end

-- cache the results of a function call
function M.memoize(f)
    local cache = nil
    return (
        function ()
            if cache == nil then
                cache = f()
            end
            return cache
        end
    )
end

-- Compare two tables, optionally ignore meta table (default FALSE)
-- source: https://web.archive.org/web/20131225070434/http://snippets.luacode.org/snippets/Deep_Comparison_of_Two_Values_3
local function deepcompare(t1, t2, ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then
        return false
    end

    -- non-table types can be directly compared
    if ty1 ~= 'table' and ty2 ~= 'table' then
        return t1 == t2
    end

    -- as well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then
        return t1 == t2
    end

    for k1,v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not M.deepcompare(v1,v2) then
            return false
        end
    end
    for k2,v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not M.deepcompare(v1,v2) then
            return false
        end
    end
    return true
end

function M.deepcompare(t1, t2)
    return deepcompare(t1, t2, true)
end

function M.deepcompare_with_meta(t1, t2)
    return deepcompare(t1, t2, false)
end

-- Get # of times elem is in list
function M.get_count(elem, list)
    local count = 0
    for _, e in pairs(list) do
        if e == elem then
            count = count + 1
        end
    end
    return count
end

-- check if Bernounilli trial results is reasonable
function M.is_prob_good(n, p, N)
    if p == 0 then
        return n == 0
    end
    if p < 0 or p > 1 then
        error('Invalid probability: ' .. p)
    end
    local std = math.sqrt(N * p * (1-p))
    local mean = N * p
    return (mean - 3*std < n and n < mean + 3*std)
end

-- Check if # times elem is in list is reasonable, assuming it had a fixed
-- probability of being in that list
function M.elem_has_good_freq(elem, list, expected_p)
    local n = M.get_count(elem, list)
    return M.is_prob_good(n, expected_p, #list)
end

return M
