require 'SarsaFactory'
require 'LinSarsa'
local LinSarsaFactory, parent = torch.class('LinSarsaFactory', 'SarsaFactory')

function LinSarsaFactory:__init(
        mdp_config,
        lambda,
        eps,
        feature_extractor,
        step_size)
    parent.__init(self, mdp_config, lambda)
    self.eps = eps
    self.feature_extractor = feature_extractor
    self.step_size = step_size
end

function LinSarsaFactory:set_eps(eps)
    self.eps = eps
end

function LinSarsaFactory:set_feature_extractor(feature_extractor)
    self.feature_extractor = feature_extractor
end

function LinSarsaFactory:get_control()
    return LinSarsa(self.mdp_config,
                    self.lambda,
                    self.eps,
                    self.feature_extractor,
                    self.step_size)
end

