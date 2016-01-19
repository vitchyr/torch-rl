require 'SAFeatureExtractor'

local TestSAFE, parent = torch.class('TestSAFE', 'SAFeatureExtractor')

-- simple feature extractor that returns the sum and difference of s and a for
-- TestMdp
function TestSAFE:get_sa_features(s, a)
    return torch.Tensor{s+a, s-a}
end

function TestSAFE:get_sa_features_dim()
    return 2
end
