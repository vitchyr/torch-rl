require 'Policy'

do
    -- A simple policy that always does the same action.
    -- Meant to go with TestMdp
    local TestPolicy, parent = torch.class('TestPolicy', 'Policy')

    function TestPolicy:__init(action)
        parent.__init(self)
        self.action = action
    end

    function TestPolicy:get_action(s)
        return self.action
    end
end

local M = {}

M.always_one = TestPolicy(1)
M.always_two = TestPolicy(2)
M.always_three = TestPolicy(3)

return M
