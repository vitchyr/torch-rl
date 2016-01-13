-- Thanks to http://stackoverflow.com/questions/34123291/torch-apply-function-over-dimension

local M = {}

function M.apply_to_slices(tensor, dimension, func, ...)
    for i, slice in ipairs(tensor:split(1, dimension)) do
        func(slice, i, ...)
    end
    return tensor
end

function M.fill_range(tensor, i, offset)
    tensor:fill(i + offset)
end

return M
