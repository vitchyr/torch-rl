require 'Policy'
local AAEP, parent = torch.class('AllActionsEqualPolicy', 'Policy')

function AAEP:__init(env)
    parent:__init(self)
    self.env = env
end

function AAEP:get_action(s)
    actions = self.env:get_all_actions()
    return actions[math.random(1, #actions)]
end

