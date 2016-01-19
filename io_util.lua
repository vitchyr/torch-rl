local M = {}
function M.save_q(fname, q)
    torch.save(fname, q)
end

function M.load_q(fname)
    return torch.load(fname)
end

return M
