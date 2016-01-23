require 'SarsaFactory'
local NNSarsaFactory, parent = torch.class('NNSarsaFactory', 'SarsaFactory')

function NNSarsaFactory:__init(
        mdp_config,
        lambda,
        explorer,
        feature_extractor,
        step_size)
    parent.__init(self, mdp_config, lambda)
    self.explorer = explorer
    self.feature_extractor = feature_extractor
    self.step_size = step_size
end

function NNSarsaFactory:set_explorer(explorer)
    self.explorer = explorer
end

function NNSarsaFactory:set_feature_extractor(feature_extractor)
    self.feature_extractor = feature_extractor
end

function NNSarsaFactory:get_control()
    return rl.NNSarsa(self.mdp_config,
                   self.lambda,
                   self.explorer,
                   self.feature_extractor,
                   self.step_size)
end

