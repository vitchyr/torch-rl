require 'TestMdp'
require 'QVAnalyzer'
local tensorutil = require 'tensorutil'

local TestMdpQVAnalyzer, parent = torch.class('TestMdpQVAnalyzer', 'QVAnalyzer')

function TestMdpQVAnalyzer:__init()
    parent.__init(self, TestMdp())
    self.n_states = #self.env.get_all_states()
    self.n_actions = #self.env.get_all_actions()
end

function TestMdpQVAnalyzer:get_v_tensor(v)
    local tensor = torch.zeros(self.n_states)
    for s = 1, self.n_states do
        tensor[s] = v:get_value(s)
    end
    return tensor
end

function TestMdpQVAnalyzer:plot_v(v)
    local tensor = self:get_v_tensor(v)
    local x = torch.Tensor(self.n_states)
    x = tensorutil.apply_to_slices(x, 1, tensorutil.fill_range, 0)
    gnuplot.plot(x, tensor)
    gnuplot.xlabel('Dealer Showing')
    gnuplot.ylabel('State Value')
    gnuplot.title('Monte-Carlo State Value Function')
end

function TestMdpQVAnalyzer:get_q_tensor(q)
    local tensor = torch.zeros(self.n_states, self.n_actions)
    for s = 1, self.n_states do
        for a = 1, self.n_actions do
            tensor[s][a] = q:get_value(s, a)
        end
    end
    return tensor
end

function TestMdpQVAnalyzer:plot_best_action(q)
    local best_action_at_state = torch.Tensor(self.n_states)
    for s = 1, self.n_states do
        best_action_at_state[s] = q:get_best_action(s)
    end
    local x = torch.Tensor(self.n_actions)
    x = tensorutil.apply_to_slices(x, 1, tensorutil.fill_range, 0)
    gnuplot.plot(x, best_action_at_state)
    gnuplot.xlabel('State')
    gnuplot.zlabel('Best Action')
    gnuplot.title('Learned Best Action Based on q')
end

function TestMdpQVAnalyzer:v_from_q(q)
    local v = VHash(self.env)
    for s = 1, self.n_states do
        local a = q:get_best_action(s)
        v:add(s, q:get_value(s, a))
    end
    return v
end
