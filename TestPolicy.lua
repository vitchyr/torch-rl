local TestPolicy, parent = torch.class('rl.TestPolicy', 'rl.Policy')

function TestPolicy:__init(action)
    parent.__init(self)
    self.action = action
end

function TestPolicy:get_action(s)
    return self.action
end
