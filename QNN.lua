require 'constants'
local util = require 'util'
local nn = require 'nn'
local nngraph = require 'nngraph'
local dpnn = require 'dpnn'

-- Implementation of a state-action value function approx using a neural network
local QNN, parent = torch.class('rl.QNN', 'rl.QApprox')

local function get_module(self)
    local x = nn.Identity()() -- use nngraph for practice
    --[[
    local l1 = nn.Linear(self.n_features, self.n_features)(x)
    local l2 = nn.Sigmoid()(l1)
    local l3 = nn.Linear(self.n_features, 1)(l1)
    local l4 = nn.Sigmoid()(l3)
    local l5 = nn.Linear(self.n_features, 1)(l4)
    return nn.gModule({x}, {l3})
    ]]--
    local l1 = nn.Linear(self.n_features, 1)(x)
    return nn.gModule({x}, {l1})
end

function QNN:is_linear()
    return true
end

function QNN:__init(mdp, feature_extractor)
    parent.__init(self, mdp, feature_extractor)
    self.n_features = feature_extractor:get_sa_num_features()
    self.module = get_module(self)
    self.is_first_update = true
end

-- This took forever to figure out. See
-- https://github.com/Element-Research/dpnn/blob/165ce5ff37d0bb77c207e82f5423ade08593d020/Module.lua#L488
-- for detail.
local function reset_momentum(net)
    net.momGradParams = nil
    if net.modules then
        for _, child in pairs(net.modules) do
            reset_momentum(child)
        end
    end
end

function QNN:reset_momentum()
    self.is_first_update = true
    self.module:zeroGradParameters()
    reset_momentum(self.module)
end

function QNN:get_value(s, a)
    local input = self.feature_extractor:get_sa_features(s, a)
    return self.module:forward(input)[1]
end

-- For now, we're ignoring eligibility. This means that the update rule to the
-- parameters W of the network is:
--
--      W <- W + step_size * td_error * dQ(s,a)/dW
--
-- We can force the network to update this way by recognizing that the "loss"
-- is literally just the output of the network. This makes it so that
--
--      dLoss/dW = dQ(s, a)/dW
--
-- So, the network will update correctly if we just tell it that the output is
-- the loss, i.e. set grad_out = 1.
--
-- For more detail where the update rule, see
-- https://webdocs.cs.ualberta.ca/~sutton/book/ebook/node89.html
--
-- For more detail on how nn works, see
-- https://github.com/torch/nn/blob/master/doc/module.md
function QNN:backward(s, a, learning_rate, momentum)
    -- forward to make sure input is set correctly
    local input = self.feature_extractor:get_sa_features(s, a)
    local output = self.module:forward(input)
    -- backward
    local grad_out = torch.ones(#output)
    self.module:zeroGradParameters()
    self.module:backward(input, grad_out)
    -- update
    -- This check is necessary because of the way updateGradParameters is
    -- implemented this. This makes sure that the first update doesn't give
    -- momentum itself. However, future updates should rely on the momentum of
    -- previous calls.
    --
    -- Also, we can't just put the call to updateGradParameters() before the
    -- call to backward() because the zeroGradParameters() call messes it up.
    if self.is_first_update then
        self.is_first_update = false
    else
        self.module:updateGradParameters(momentum, 0, false) -- momentum (dpnn)
    end
    self.module:updateParameters(-learning_rate) -- W = W - rate * dL/dW
end

QNN.__eq = parent.__eq -- force inheritance of this
