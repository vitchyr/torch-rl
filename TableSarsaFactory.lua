require 'SarsaFactory'
require 'TableSarsa'
local TableSarsaFactory, parent = torch.class('TableSarsaFactory', 'SarsaFactory')

function TableSarsaFactory:get_control()
    return TableSarsa(
        self.mdp_config,
        self.lambda)
end

