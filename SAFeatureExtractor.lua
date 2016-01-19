-- Feature extractor for a state-action pair.
local SAFeatureExtractor = torch.class('SAFeatureExtractor')

function SAFeatureExtractor:__init()
end

function SAFeatureExtractor:get_sa_features(s, a)
    error('Must implement get_sa_features')
end

