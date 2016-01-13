require 'constants'

local M = {}

local dealer_values = {
    {1, 4}, {4, 7}, {7, 10}
}
local player_values = {
    {1, 6},
    {4, 9},
    {7, 12},
    {10, 15},
    {13, 18},
    {16, 21}
}

-- Features are a coarse coding.
function M.get_features(s, a)
    local dealer, player = table.unpack(s)
    local x = torch.zeros(3, 6, 2)
    local dealer_i, player_i = 0, 0

    local function is_in(v, range)
        local a, b = table.unpack(range)
        return a <= v and v <= b
    end

    for dealer_i, dealer_range in pairs(dealer_values) do
        for player_i, player_range in pairs(player_values) do
            if is_in(dealer, dealer_range) and is_in(player, player_range) then
                x[dealer_i][player_i][a] = 1
            end
        end
    end

    return x:resize(36)
end

function M.get_onehot_features(s, a)
    local x = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES, N_ACTIONS)
    local dealer, player = table.unpack(s)
    x[dealer][player][a] = 1

    return x:resize(N_DEALER_STATES * N_PLAYER_STATES * N_ACTIONS)
end

return M
