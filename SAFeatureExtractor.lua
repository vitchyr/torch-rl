-- Feature extractor for a state-action pair.
local SAFeatureExtractor = torch.class('rl.SAFeatureExtractor')

function SAFeatureExtractor:__init()
end

-- returns a Tensor that represents the features of a given state-action pair
function SAFeatureExtractor:get_sa_features(s, a)
    error('Must implement get_sa_features')
end

-- returns the dimension of the output of get_sa_features
function SAFeatureExtractor:get_sa_features_dim()
    error('Must implement get_sa_features_dim')
end

-- returns the num of elements in the tensor returned by get_sa_features
function SAFeatureExtractor:get_sa_num_features()
    error('Must implement get_sa_num_features')
end
