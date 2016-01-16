require 'constants'

local M = {}

function M.get_q_tensor(q)
    local tensor = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES, N_ACTIONS)
    for dealer = 1, N_DEALER_STATES do
        for player = 1, N_PLAYER_STATES do
            for a = 1, N_ACTIONS do
                s = {dealer, player}
                tensor[s][a] = q:get_tensor(s, a)
            end
        end
    end
    return tensor
end

function M.get_v_tensor(v)
    local value = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES)
    for dealer = 1, N_DEALER_STATES do
        for player = 1, N_PLAYER_STATES do
            s = {dealer, player}
            value[s] = v:get_value(s)
        end
    end
    return value
end

return M
