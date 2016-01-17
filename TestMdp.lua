require 'Mdp'

-- Dummy MDP for testing
-- state = either 1, 2, or 3
-- action = either 1, 2, or 3
local TestMdp, parent = torch.class('TestMdp', 'Mdp')

local TERMINAL = 3

function TestMdp:step(s, a)
    if TestMdp:is_terminal(s) then
        error('MDP is done.')
    end
    local reward = -1
    if s + a >= 4 then
        reward = 1
    end
    return s + 1, reward
end

function TestMdp:get_start_state()
    return 1
end

function TestMdp:get_all_states()
    return {1, 2, 3}
end

function TestMdp:get_all_actions()
    return {1, 2, 3}
end

function TestMdp:hash_s(s)
    return s
end

function TestMdp:hash_a(a)
    return a
end

function TestMdp:copy_state(s)
    return s
end

function TestMdp:is_terminal(s)
    return s == TERMINAL
end

function TestMdp:get_description()
    return 'Test MDP'
end
