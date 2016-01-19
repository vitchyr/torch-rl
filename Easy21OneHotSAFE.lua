require 'SAFeatureExtractor'
require 'easy21_constants'

-- Features are a coarse coding.
local Easy21OneHotSAFE, parent = torch.class('Easy21OneHotSAFE', 'SAFeatureExtractor')

function Easy21OneHotSAFE:get_sa_features(s, a)
    local x = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES, N_ACTIONS)
    local dealer, player = table.unpack(s)
    x[dealer][player][a] = 1

    return x:resize(N_DEALER_STATES * N_PLAYER_STATES * N_ACTIONS)
end

function Easy21OneHotSAFE:get_sa_features_dim()
    return N_DEALER_STATES * N_PLAYER_STATES * N_ACTIONS
end
