-- Analyze different control algorithms.
local io_util = require 'io_util'
require 'constants'
require 'MonteCarloControl'
local gnuplot = require 'gnuplot'

local SarsaAnalyzer = torch.class('SarsaAnalyzer')

function SarsaAnalyzer:__init(opt, mdp_config, qvanalyzer, sarsa_factory)
    self.loadqfrom = opt.loadqfrom
    self.save = opt.save
    self.show = opt.show
    self.rms_num_points = opt.rms_num_points
    self.n_iters = opt.n_iters or N_ITERS

    self.mdp_config = mdp_config
    self.qvanalyzer = qvanalyzer
    self.sarsa_factory = sarsa_factory

    self.q_mc = nil
end

function SarsaAnalyzer:get_true_q(n_iters)
    if self.loadqfrom ~= nil and self.loadqfrom ~= '' then
        print('Loading q_mc from ' .. self.loadqfrom)
        return io_util.load_q(self.loadqfrom)
    end

    self.n_iters = n_iters or self.n_iters
    local mc = MonteCarloControl(self.mdp_config)
    print('Computing Q from Monte Carlo. # iters = ' .. self.n_iters)
    mc:improve_policy_for_n_iters(self.n_iters)

    return  mc:get_q()
end

local function plot_rms_lambda_data(data)
    gnuplot.plot(data)
    gnuplot.grid(true)
    gnuplot.xlabel('lambda')
    gnuplot.ylabel('RMS between Q-MC and Q-SARSA')
    gnuplot.title('Q RMS after 1000 episodes vs lambda')
end

local function get_sarsa(self, lambda)
    self.sarsa_factory:set_lambda(lambda)
    return self.sarsa_factory:get_control()
end

local function plot_results(self, plot_function, image_fname)
    if self.show then
        gnuplot.figure()
        plot_function()
    end
    if self.save then
        gnuplot.epsfigure(image_fname)
        print('Saving plot to: ' .. image_fname)
        plot_function()
        gnuplot.plotflush()
    end
end

local function get_lambda_data(self)
    local rms_lambda_data = torch.Tensor(11, 2)
    local i = 1
    print('Generating data/plot for varying lambdas.')
    for lambda = 0, 1, 0.1 do
        print('Processing SARSA for lambda = ' .. lambda)
        local sarsa = get_sarsa(self, lambda)
        sarsa:improve_policy(self.n_iters)
        local q = sarsa:get_q()
        rms_lambda_data[i][1] = lambda
        rms_lambda_data[i][2] = self.qvanalyzer:q_rms(q, self.q_mc)
        i = i + 1
    end
    return rms_lambda_data
end

-- For a given control algorithm, see how the RMS changes with lambda.
-- Sweeps and plots the performance for lambda = 0, 0.1, 0.2, ..., 1.0
function SarsaAnalyzer:eval_lambdas(
        image_fname,
        n_iters)
    self.q_mc = self.q_mc or self:get_true_q()
    self.n_iters = n_iters or self.n_iters
    local rms_lambda_data = torch.Tensor(11, 2)
    local i = 1
    print('Generating data/plot for varying lambdas.')
    for lambda = 0, 1, 0.1 do
        print('Processing SARSA for lambda = ' .. lambda)
        local sarsa = get_sarsa(self, lambda)
        sarsa:improve_policy_for_n_iters(self.n_iters)
        local q = sarsa:get_q()
        rms_lambda_data[i][1] = lambda
        rms_lambda_data[i][2] = self.qvanalyzer:q_rms(q, self.q_mc)
        i = i + 1
    end

    plot_results(self,
                 function ()
                     plot_rms_lambda_data(rms_lambda_data)
                 end,
                 image_fname)
end

local function plot_rms_episode_data(data_table)
    for lambda, data in pairs(data_table) do
        gnuplot.plot({tostring(lambda), data})
    end

    gnuplot.plot({'0', data[0]},
                 {'1', data[1]})
    gnuplot.grid(true)
    gnuplot.xlabel('Episode')
    gnuplot.ylabel('RMS between Q-MC and Q-SARSA')
    gnuplot.title('Q RMS vs Episode, lambda = 0 and 1')
end

-- hack to get around that torch doesn't seem to allow private class methods
local function get_rms_episode_data(self, lambda)
    local rms_episode_data = torch.Tensor(self.rms_num_points, 2)
    local sarsa = get_sarsa(self, lambda)
    sarsa:improve_policy()
    local q = sarsa:get_q()
    rms_episode_data[1][1] = 1
    rms_episode_data[1][2] = self.qvanalyzer:q_rms(q, self.q_mc)
    local n_iters_per_data_point = self.n_iters / self.rms_num_points
    local i = n_iters_per_data_point
    for j = 2, self.rms_num_points do
        sarsa:improve_policy_for_n_iters(n_iters_per_data_point)
        q = sarsa:get_q()
        rms_episode_data[j][1] = i
        rms_episode_data[j][2] = self.qvanalyzer:q_rms(q, self.q_mc)
        i = i + n_iters_per_data_point
    end
    return rms_episode_data
end

-- For a given control algorithm, see how the RMS changes with # of episodes for
-- lambda = 0 and lambda = 1.
function SarsaAnalyzer:eval_l0_l1_rms(
        image_fname,
        n_iters)
    self.q_mc = self.q_mc or self:get_true_q()
    n_iters = n_iters or self.n_iters

    print('Generating data for RMS vs episode')
    local l0_data = get_rms_episode_data(self, 0)
    local l1_data = get_rms_episode_data(self, 1)
    data = {}
    data[0] = l0_data
    data[1] = l1_data

    print('Generating plots for RMS vs episode')
    plot_results(self,
                 function ()
                     plot_rms_episode_data(data)
                 end,
                 image_fname)
end
