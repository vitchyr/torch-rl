require 'constants'
require 'Easy21'
require 'QVAnalyzer'
local tensorutil = require 'tensorutil'

local Easy21QVAnalyzer, parent = torch.class('Easy21QVAnalyzer', 'QVAnalyzer')

function Easy21QVAnalyzer:__init()
    parent.__init(self, Easy21())
end

function Easy21QVAnalyzer:get_v_tensor(v)
    local tensor = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES)
    for dealer = 1, N_DEALER_STATES do
        for player = 1, N_PLAYER_STATES do
            s = {dealer, player}
            tensor[s] = v:get_value(s)
        end
    end
    return tensor
end

function Easy21QVAnalyzer:plot_v(v)
    -- row = dealer, from 1 to N_DEALER_STATES
    -- col = player, from 1 to N_PLAYER_STATES
    local tensor = self:get_v_tensor(v)

    local x = torch.Tensor(N_DEALER_STATES, N_PLAYER_STATES)
    x = tensorutil.apply_to_slices(x, 1, tensorutil.fill_range, 0)
    local y = torch.Tensor(N_DEALER_STATES, N_PLAYER_STATES)
    y = tensorutil.apply_to_slices(y, 2, tensorutil.fill_range, 0)
    gnuplot.splot(x, y, tensor)
    gnuplot.xlabel('Dealer Showing')
    gnuplot.ylabel('Player Sum')
    gnuplot.zlabel('State Value')
    gnuplot.title('Monte-Carlo State Value Function')
end

function Easy21QVAnalyzer:plot_best_action(q)
    local best_action_at_state = torch.Tensor(N_DEALER_STATES, N_PLAYER_STATES)
    for dealer = 1, N_DEALER_STATES do
        for player = 1, N_PLAYER_STATES do
            local s = {dealer, player}
            best_action_at_state[dealer][player] = q:get_best_action(s)
        end
    end
    local x = torch.Tensor(N_DEALER_STATES, N_PLAYER_STATES)
    x = tensorutil.apply_to_slices(x, 1, tensorutil.fill_range, 0)
    local y = torch.Tensor(N_DEALER_STATES, N_PLAYER_STATES)
    y = tensorutil.apply_to_slices(y, 2, tensorutil.fill_range, 0)
    gnuplot.splot(x, y, best_action_at_state)
    gnuplot.xlabel('Dealer Showing')
    gnuplot.ylabel('Player Sum')
    gnuplot.zlabel('Best Action')
    gnuplot.title('Learned Best Action Based on q')
end

function Easy21QVAnalyzer:get_q_tensor(q)
    local tensor = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES, N_ACTIONS)
    for dealer = 1, N_DEALER_STATES do
        for player = 1, N_PLAYER_STATES do
            for a = 1, N_ACTIONS do
                s = {dealer, player}
                tensor[s][a] = q:get_value(s, a)
            end
        end
    end
    return tensor
end

function Easy21QVAnalyzer:v_from_q(q)
    local v = VHash(self.mdp)
    for dealer = 1, N_DEALER_STATES do
        for player = 1, N_PLAYER_STATES do
            local s = {dealer, player}
            local a = q:get_best_action(s)
            v:add(s, q:get_value(s, a))
        end
    end
    return v
end
