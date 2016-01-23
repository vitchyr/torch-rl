local ControlFactory = torch.class('rl.ControlFactory')

function ControlFactory:__init(mdp_config)
    self.mdp_config = mdp_config
end

function ControlFactory:set_mdp_config(mdp_config)
    self.mdp_config = mdp_config
end

function ControlFactory:get_control()
    error('Must implement get_control')
end
