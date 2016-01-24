-- Thanks to http://stackoverflow.com/questions/34123291/torch-apply-function-over-dimension
function rl.util.apply_to_slices(tensor, dimension, func, ...)
    for i, slice in ipairs(tensor:split(1, dimension)) do
        func(slice, i, ...)
    end
    return tensor
end

function rl.util.fill_range(tensor, i, offset)
    tensor:fill(i + offset)
end

