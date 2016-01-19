require 'SAFeatureExtractor'
require 'easy21_constants'

-- Features are a coarse coding.
local Easy21BoxSAFE, parent = torch.class('Easy21BoxSAFE', 'SAFeatureExtractor')

function Easy21BoxSAFE:get_sa_features(s, a)
    local dealer, player = table.unpack(s)
    local x = torch.zeros(3, 6, 2)
    local dealer_i, player_i = 0, 0

    local function is_in(v, range)
        local a, b = table.unpack(range)
        return a <= v and v <= b
    end

    for dealer_i, dealer_range in pairs(DEALER_VALUES) do
        for player_i, player_range in pairs(PLAYER_VALUES) do
            if is_in(dealer, dealer_range) and is_in(player, player_range) then
                x[dealer_i][player_i][a] = 1
            end
        end
    end

    return x:resize(36)
end

function Easy21BoxSAFE:get_sa_features_dim()
    return 36
end
