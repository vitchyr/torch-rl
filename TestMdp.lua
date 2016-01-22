require 'Mdp'

-- Dummy MDP for testing
-- state = either 1, 2, or 3
-- action = either 1, 2, or 3
local TestMdp, parent = torch.class('TestMdp', 'Mdp')

local TERMINAL = 3

function TestMdp:step(state, action)
    if TestMdp:is_terminal(state) then
        error('MDP is done.')
    end
    local reward = -1
    if state + action >= 4 then
        reward = 1
    end
    return state + 1, reward
end

function TestMdp:get_start_state()
    return 1
end

function TestMdp:is_terminal(s)
    return s == TERMINAL
end

function TestMdp:get_all_states()
    return {1, 2, 3}
end

function TestMdp:get_all_actions()
    return {1, 2, 3}
end

function TestMdp:hash_s(state)
    return state
end

function TestMdp:hash_a(action)
    return action
end

function TestMdp:get_description()
    return 'Test MDP'
end
