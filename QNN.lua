require 'constants'
require 'QApprox'
local util = require 'util'
local nn = require 'nn'
local nngraph = require 'nngraph'
local dpnn = require 'dpnn'

-- Implementation of a state-action value function approx using a neural network
local QNN, parent = torch.class('QNN', 'QApprox')

function QNN:__init(mdp, feature_extractor)
    parent.__init(self, mdp, feature_extractor)
    self.n_features = feature_extractor:get_sa_num_features()
    self.module = self:get_module()
end

-- Get the NN module
function QNN:get_module()
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

function QNN:clear()
    self.module = self:get_module()
end

function QNN:get_value(s, a)
    local input = self.feature_extractor:get_sa_features(s, a)
    return self.module:forward(input)[1]
end

function QNN:backward(td_error, s, a, alpha, lambda)
    -- forward to make sure input is set correctly
    local input = self.feature_extractor:get_sa_features(s, a)
    local output = self.module:forward(input)
    -- backward
    -- The output of interest is the output of this layer. So grad_out = 1
    local grad_out = torch.ones(#output)
    self.module:zeroGradParameters()
    self.module:backward(input, grad_out)
    -- update
    --self.module:updateGradParameters(1 - lambda) -- momentum (dpnn)
    self.module:updateParameters(-alpha*td_error) -- W = W - rate * dL/dW
end

function QNN:add(d_weights)
    self.weights = self.weights + d_weights
end

function QNN:mult(factor)
    self.weights = self.weights * factor
end

function QNN:get_weight_vector()
    return self.weights
end

QNN.__eq = parent.__eq -- force inheritance of this
