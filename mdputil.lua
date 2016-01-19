local util = require 'util'

local M = {}
-- Get a table, where all the state keys have been initialized to 0
function M.get_all_states_map(mdp)
    all_states_map = {}
    for k, s in pairs(mdp:get_all_states()) do
        all_states_map[mdp:hash_s(s)] = 0
    end
    return all_states_map
end

function M.get_all_states_action_map(mdp)
    all_states_actions_map = {}
    for k, s in pairs(mdp:get_all_states()) do
        local actions_map = {}
        for _, a in pairs(mdp:get_all_actions()) do
            actions_map[mdp:hash_a(a)] = 0
        end
        all_states_actions_map[mdp:hash_s(s)] = actions_map
    end
    return all_states_actions_map
end

return M
