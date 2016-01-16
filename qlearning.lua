local agent = require 'agent'
local util = require 'util'
local env = require 'easy21'
local envutil = require 'envutil'
local QHash = require 'QHash'
local VHash = require 'VHash'

local M = {}

-- epsilon-greedy exploration
function M.eps_greedy_improve_policy(Q, Ns)
    return function (s)
        local eps = N0 / (N0 + Ns:get_value(s))

        actions = env.get_all_actions()
        n_actions = #actions
        pi = {}
        for k, a in pairs(actions) do
            pi[a] = eps / n_actions
        end

        -- Add 1-eps to best action
        best_a = Q:get_best_action(s)
        pi[best_a] = pi[best_a] + 1 - eps

        return util.weighted_random_choice(pi)
    end
end

function M.const_eps_greedy_improve_policy(Q, eps)
    return function (s)
        actions = env.get_all_actions()
        n_actions = #actions
        pi = {}
        for k, a in pairs(actions) do
            pi[a] = eps / n_actions
        end

        -- Add 1-eps to best action
        best_a = Q:get_best_action(s)
        pi[best_a] = pi[best_a] + 1 - eps

        return util.weighted_random_choice(pi)
    end
end

function M.get_policy_params(n_iters, eval_policy_fn)
    local Q = QHash:new()
    local Ns = VHash:new()  -- can reuse V and Q as general tables for Q and V
    local Nsa = QHash:new()
    for i = 1, n_iters do
        policy = M.eps_greedy_improve_policy(Q, Ns)
        Q, Ns, Nsa = eval_policy_fn(policy, agent, Q, Ns, Nsa)
    end
    return Q, Ns
end

function M.get_policy(n_iters, eval_policy_fn)
    Q, Ns = M.get_policy_params(n_iters, eval_policy_fn)
    return M.eps_greedy_improve_policy(Q, Ns)
end

return M
