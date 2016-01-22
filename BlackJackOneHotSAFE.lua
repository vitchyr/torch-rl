require 'SAFeatureExtractor'
require 'BlackJack_constants'

-- Features are a coarse coding.
local BlackJackOneHotSAFE, parent = torch.class('BlackJackOneHotSAFE', 'SAFeatureExtractor')

local N_FEATURES = N_DEALER_STATES * N_PLAYER_STATES * N_ACTIONS
function BlackJackOneHotSAFE:get_sa_features(s, a)
    local x = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES, N_ACTIONS)
    local dealer, player = table.unpack(s)
    x[dealer][player][a] = 1

    return x:resize(N_FEATURES)
end

function BlackJackOneHotSAFE:get_sa_features_dim()
    return N_FEATURES
end

function BlackJackOneHotSAFE:get_sa_num_features()
    return N_FEATURES
end
