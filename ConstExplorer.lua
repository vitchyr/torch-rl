require 'Explorer'
--- Explore with a fixed probability
local ConstExplorer = torch.class('ConstExplorer', 'Explorer')

function ConstExplorer:__init(p)
    self.p = p
end

function ConstExplorer:get_eps(s)
    return self.p
end
