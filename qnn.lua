require 'constants'
local envutil = require 'envutil'
local env = require 'easy21'
local util = require 'util'
local fe = require 'featureextraction'
local qa = require 'qapprox'
local nn = require 'nn'
local nngraph = require 'nngraph'
local dpnn = require 'dpnn'

-- Implementation of a state-action value function approx using a neural network

local M = {}

do
    local Q, parent = torch.class('QNN', 'QApprox')

    function Q:__init()
        parent.__init(self)
        self.n_features = N_DEALER_STATES * N_PLAYER_STATES * N_ACTIONS
        self.module = self:get_module()
    end

    -- Get the NN module
    function Q:get_module()
        local x = nn.Identity()() -- use nngraph for practice
        local l1 = nn.Linear(self.n_features, 1)(x)
        --[[
        local l2 = nn.Sigmoid()(l1)
        local l3 = nn.Linear(self.n_features, self.n_features)(l2)
        local l4 = nn.Sigmoid()(l3)
        local l5 = nn.Linear(self.n_features, 1)(l4)
        --]]
        return nn.gModule({x}, {l1})
    end

    function Q:clear()
        self.module = self:get_module()
    end

    function Q:get_value(s, a)
        local input = fe.get_onehot_features(s, a)
        return self.module:forward(input)[1]
    end

    function Q:backward(td_error, s, a, alpha, lambda)
        -- forward to make sure input is set correctly
        local input = fe.get_onehot_features(s, a)
        local output = self.module:forward(input)
        -- backward
        local gradOutput = torch.Tensor{td_error}
        self.module:zeroGradParameters()
        local gradInput = self.module:backward(input, gradOutput)
        -- update
        --self.module:updateGradParameters(1 - lambda) -- momentum (dpnn)
        self.module:updateParameters(-alpha) -- W = W - alpha * dL/dW
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
M.QNN = QNN

return M
