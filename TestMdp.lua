-- Dummy MDP for testing
-- state = either 1, 2, or 3
-- action = either 1, 2, or 3
local M = {}

local TERMINAL = 3

function M.step(s, a)
    if M.is_terminal(s) then
        error('MDP is done.')
    end
    local reward = -1
    if s + a > 4 then
        reward = 1
    end
    return s + 1, reward
end

function M.get_start_state()
    return 1
end

function M.get_all_states()
    return {1, 2, 3}
end

function M.get_all_actions()
    return {1, 2, 3}
end

function M.hash_s(s)
    return s
end

function M.hash_a(a)
    return a
end

function M.copy_state(s)
    return s
end

function M.is_terminal(s)
    return s == TERMINAL
end

return M
