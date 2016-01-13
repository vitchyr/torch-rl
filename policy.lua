local M = {}

do
    local Policy = torch.class('rl.Policy')

    function Policy:__init()
    end

    --- Return an action given a state
    function Policy:get_action(s)
        error('Policy must implement get_action')
    end
end
M.Policy = Policy

return M
