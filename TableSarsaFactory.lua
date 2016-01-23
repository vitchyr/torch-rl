require 'SarsaFactory'
local TableSarsaFactory, parent = torch.class('TableSarsaFactory', 'SarsaFactory')

function TableSarsaFactory:get_control()
    return rl.TableSarsa(
        self.mdp_config,
        self.lambda)
end

