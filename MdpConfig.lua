local MdpConfig = torch.class('rl.MdpConfig')

function MdpConfig:__init(mdp, discount_factor)
    self.mdp = mdp
    if discount_factor < 0 or discount_factor > 1 then
        error('Gamma must be between 0 and 1, inclusive.')
    end
    self.discount_factor = discount_factor
end

function MdpConfig:get_mdp()
    return self.mdp
end

function MdpConfig:get_discount_factor()
    return self.discount_factor
end

function MdpConfig:get_description()
    return self.mdp:get_description() .. "-Gamma="..self.discount_factor
end
