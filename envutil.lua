local util = require 'util'

local M = {}
-- Get a table, where all the state keys have been initialized to 0
local all_states_map = nil
function M.get_all_states_map(env)
    if all_states_map == nil then
        all_states_map = {}
        for k, s in pairs(env.get_all_states()) do
            all_states_map[env.hash_s(s)] = 0
        end
    end
    return util.copy_simply(all_states_map)
end

local all_states_actions_map = nil
function M.get_all_states_action_map(env)
    if all_states_actions_map == nil then
        all_states_actions_map = {}
        for k, s in pairs(env.get_all_states()) do
            local actions_map = {}
            for _, a in pairs(env.get_all_actions()) do
                actions_map[env.hash_a(a)] = 0
            end
            all_states_actions_map[env.hash_s(s)] = actions_map
        end
    end
    return util.copy_simply(all_states_actions_map)
end

return M
