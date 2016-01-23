require 'rl'
require 'BlackJack_constants'

-- Features are a coarse coding.
local BlackJackBoxSAFE, parent =
    torch.class('BlackJackBoxSAFE', 'rl.SAFeatureExtractor')

local N_FEATURES = #DEALER_VALUES * #PLAYER_VALUES * N_ACTIONS
function BlackJackBoxSAFE:get_sa_features(s, a)
    local dealer, player = table.unpack(s)
    local x = torch.zeros(#DEALER_VALUES, #PLAYER_VALUES, N_ACTIONS)
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

    return x:resize(N_FEATURES)
end

function BlackJackBoxSAFE:get_sa_features_dim()
    return N_FEATURES
end

function BlackJackBoxSAFE:get_sa_num_features()
    return N_FEATURES
end
