require 'VHash'
require 'constants'
local gnuplot = require 'gnuplot'
local tensorutil = require 'tensorutil'

local QVAnalyzer = torch.class('QVAnalyzer')

function QVAnalyzer:__init(env)
    self.env = env
end

function QVAnalyzer:get_v_tensor(v)
    error('Must implement get_v_tensor.')
end

-- Plot the state value function
function QVAnalyzer:plot_v(v)
    -- row = dealer, from 1 to N_DEALER_STATES
    -- col = player, from 1 to N_PLAYER_STATES
    local value = self:get_v_tensor(v)

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

function QVAnalyzer:plot_action(q, method)
    local action = torch.Tensor(N_DEALER_STATES, N_PLAYER_STATES)
    for dealer = 1, N_DEALER_STATES do
        for player = 1, N_PLAYER_STATES do
            local s = {dealer, player}
            action[dealer][player] = q:get_best_action(s)
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
        gnuplot.title('Best Action Based on q')
    else
        gnuplot.title('Best Action Based on q, from ' .. method)
    end
end

function QVAnalyzer:v_from_q(q)
    error('Must implement v_from_q')
end

function QVAnalyzer:get_q_tensor(q)
    error('Must implement get_q_tensor.')
end

function QVAnalyzer:q_rms(q1, q2)
    local t1 = self:get_q_tensor(q1)
    local t2 = self:get_q_tensor(q2)
    return torch.sum(torch.pow(t1 - t2, 2))
end

return M
