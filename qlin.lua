require 'constants'
local util = require 'util'
local fe = require 'featureextraction'
local qa = require 'qapprox'

-- Implementation of a state-action value function approx using linear function
-- of features

local M = {}

do
    local Q, parent = torch.class('QLin', 'QApprox')

    function Q:__init()
        parent.__init(self)
        self.weights = torch.rand(N_FEATURES)
    end

    function Q:clear()
        self.weights = torch.zeros(N_FEATURES)
    end

    function Q:get_value(s, a)
        return self.weights:dot(fe.get_features(s, a))
    end

    function Q:add(d_weights)
        self.weights = self.weights + d_weights
    end

    function Q:mult(factor)
        self.weights = self.weights * factor
    end

    function Q:get_weight_vector()
        return self.weights
    end
end
M.QLin = QLin

return M
