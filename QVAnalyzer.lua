require 'constants'
local gnuplot = require 'gnuplot'

local QVAnalyzer = torch.class('rl.QVAnalyzer')

function QVAnalyzer:__init(mdp)
    self.mdp = mdp
end
function QVAnalyzer:get_v_tensor(v)
    error('Must implement get_v_tensor.')
end

-- Plot the state value function
function QVAnalyzer:plot_v(v)
    error('Must implement plot_v.')
end

function QVAnalyzer:plot_best_action(q, method_description)
    error('Must implement plot_best_action.')
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

function QVAnalyzer:v_rms(v1, v2)
    local t1 = self:get_v_tensor(v1)
    local t2 = self:get_v_tensor(v2)
    return torch.sum(torch.pow(t1 - t2, 2))
end
