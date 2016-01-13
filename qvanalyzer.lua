local VHash = require 'vhash'
local env = require 'easy21'
local gnuplot = require 'gnuplot'
local tensorutil = require 'tensorutil'

local M = {}

-- Plot the state value function
function M.plot_v(V)
    -- row = dealer, from 1 to N_DEALER_STATES
    -- col = player, from 1 to N_PLAYER_STATES
    local value = V:get_v_tensor()

    local x = torch.Tensor(N_DEALER_STATES, N_PLAYER_STATES)
    x = tensorutil.apply_to_slices(x, 1, tensorutil.fill_range, 0)
    local y = torch.Tensor(N_DEALER_STATES, N_PLAYER_STATES)
    y = tensorutil.apply_to_slices(y, 2, tensorutil.fill_range, 0)
    gnuplot.splot(x, y, value)
    gnuplot.xlabel('Dealer Showing')
    gnuplot.ylabel('Player Sum')
    gnuplot.zlabel('State Value')
    gnuplot.title('Monte-Carlo State Value Function')
end

function M.plot_action(Q, method)
    local action = torch.Tensor(N_DEALER_STATES, N_PLAYER_STATES)
    for dealer = 1, N_DEALER_STATES do
        for player = 1, N_PLAYER_STATES do
            local s = {dealer, player}
            action[dealer][player] = Q:get_best_action(s)
        end
    end
    local x = torch.Tensor(N_DEALER_STATES, N_PLAYER_STATES)
    x = tensorutil.apply_to_slices(x, 1, tensorutil.fill_range, 0)
    local y = torch.Tensor(N_DEALER_STATES, N_PLAYER_STATES)
    y = tensorutil.apply_to_slices(y, 2, tensorutil.fill_range, 0)
    gnuplot.splot(x, y, action)
    gnuplot.xlabel('Dealer Showing')
    gnuplot.ylabel('Player Sum')
    gnuplot.zlabel('Action')
    if method == nil then
        gnuplot.title('Best Action Based on Q')
    else
        gnuplot.title('Best Action Based on Q, from ' .. method)
    end
end

function M.v_from_q(Q)
    local V = VHash:new()
    for dealer = 1, N_DEALER_STATES do
        for player = 1, N_PLAYER_STATES do
            local s = {dealer, player}
            local a = Q:get_best_action(s)
            V:add(s, Q:get_value(s, a))
        end
    end
    return V
end

function M.q_rms(Q1, Q2)
    local t1 = Q1:get_q_tensor()
    local t2 = Q2:get_q_tensor()
    return torch.sum(torch.pow(t1 - t2, 2))
end

return M
