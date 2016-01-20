require 'ControlFactory'
local SarsaFactory, parent = torch.class('SarsaFactory', 'ControlFactory')

function SarsaFactory:__init(mdp_config, lambda)
    parent.__init(self, mdp_config)
    self.lambda = lambda
end

function SarsaFactory:set_lambda(lambda)
    self.lambda = lambda
end
