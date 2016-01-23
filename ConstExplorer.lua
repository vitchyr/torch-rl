--- Explore with a fixed probability
local ConstExplorer = torch.class('rl.ConstExplorer', 'rl.Explorer')

function ConstExplorer:__init(p)
    self.p = p
end

function ConstExplorer:get_eps(s)
    return self.p
end

function ConstExplorer:__eq(other)
    return torch.typename(self) == torch.typename(other)
        and self.p == other.p
end
