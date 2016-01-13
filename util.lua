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

return M
