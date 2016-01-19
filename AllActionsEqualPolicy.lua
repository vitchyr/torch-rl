require 'Policy'
local AAEP, parent = torch.class('AllActionsEqualPolicy', 'Policy')

function AAEP:__init(mdp)
    parent:__init(self)
    self.mdp = mdp
end

function AAEP:get_action(s)
    actions = self.mdp:get_all_actions()
    return actions[math.random(1, #actions)]
end

