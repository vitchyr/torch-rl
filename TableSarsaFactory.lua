require 'rl'
local TableSarsaFactory, parent =
    torch.class('rl.TableSarsaFactory', 'rl.SarsaFactory')

function TableSarsaFactory:get_control()
    return rl.TableSarsa(
        self.mdp_config,
        self.lambda)
end

