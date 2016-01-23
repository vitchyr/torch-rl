local LinSarsaFactory, parent =
    torch.class('rl.LinSarsaFactory', 'rl.SarsaFactory')

function LinSarsaFactory:__init(
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

function LinSarsaFactory:set_explorer(explorer)
    self.explorer = explorer
end

function LinSarsaFactory:set_feature_extractor(feature_extractor)
    self.feature_extractor = feature_extractor
end

function LinSarsaFactory:get_control()
    return rl.LinSarsa(self.mdp_config,
                    self.lambda,
                    self.explorer,
                    self.feature_extractor,
                    self.step_size)
end

