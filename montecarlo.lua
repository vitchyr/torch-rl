-- Use monte carlo to update the predicted value function
local M = {}

function M.montecarlo_eval_policy(policy, agent, Q, Ns, Nsa)
    local episode = agent.get_episode(policy)
    for t, data in pairs(episode) do
        local s, a, Gt = table.unpack(data)

        Ns:add(s, 1)
        Nsa:add(s, a, 1)

        alpha = 1. / Nsa:get_value(s, a)
        Q:add(s, a, alpha * (Gt - Q:get_value(s, a)))
    end
    return Q, Ns, Nsa
end

return M
