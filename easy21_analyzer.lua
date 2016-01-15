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

return M
