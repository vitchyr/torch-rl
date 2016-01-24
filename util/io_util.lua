function rl.util.save_q(fname, q)
    torch.save(fname, q)
end

function rl.util.load_q(fname)
    return torch.load(fname)
end
