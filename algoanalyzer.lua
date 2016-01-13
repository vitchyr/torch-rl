-- Analyze different control algorithms.
require 'constants'
local mc = require 'montecarlo'
local qlearning = require 'qlearning'
local gnuplot = require 'gnuplot'
local qva = require 'qvanalyzer'

local M = {}

do 
    local AA = torch.class('AlgoAnalyzer')

    function AA:__init(opt, env)
        self.loadqfrom = opt.loadqfrom
        self.save = opt.save
        self.show = opt.show
        self.rms_plot_freq = opt.rms_plot_freq
        self.env = env
        self.n_iters = opt.n_iters or N_ITERS
        self.Q_mc = nil
    end

    function AA:get_true_q(n_iters)
        if self.loadqfrom ~= nil and self.loadqfrom ~= '' then
            print('Loading Q_mc from ' .. self.loadqfrom)
            local Q, mt = table.unpack(torch.load(self.loadqfrom))
            setmetatable(Q, mt)
            return Q
        end
        
        n_iters = n_iters or self.n_iters
        print('Computing Q from Monte Carlo. # iters = ' .. n_iters)
        local Q = qlearning.get_policy_params(
            n_iters,
            mc.montecarlo_eval_policy)
        return Q
    end

    local function plot_rms_lambda_data(data)
        gnuplot.plot(data)
        gnuplot.grid(true)
        gnuplot.xlabel('lambda')
        gnuplot.ylabel('RMS between Q-MC and Q-SARSA')
        gnuplot.title('Q RMS after 1000 episodes vs lambda')
    end

    -- For a given control algorithm, see how the RMS changes with lambda.
    -- Sweeps and plots the performance for lambda = 0, 0.1, 0.2, ..., 1.0
    function AA:eval_lambdas(
            Sarsa,
            image_fname,
            n_iters)
        self.Q_mc = self.Q_mc or self:get_true_q()
        n_iters = n_iters or self.n_iters
        local rms_lambda_data = torch.Tensor(11, 2)
        local i = 1
        print('Generating data/plot for varying lambdas.')
        for lambda = 0, 1, 0.1 do
            print('Processing SARSA for lambda = ' .. lambda)
            sarsa = Sarsa(lambda, self.env)
            local Q = sarsa:improve(n_iters):get_Q()
            rms_lambda_data[i][1] = lambda
            rms_lambda_data[i][2] = qva.q_rms(Q, self.Q_mc)
            i = i + 1
        end

        if self.show then
            gnuplot.figure()
            plot_rms_lambda_data(rms_lambda_data)
        end
        if self.save then
            print('Saving lambda sweep plot to: ' .. image_fname)
            gnuplot.epsfigure(image_fname)
            plot_rms_lambda_data(rms_lambda_data)
            gnuplot.plotflush()
        end
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
        gnuplot.title('Q RMS vs Episode, lambda = 0 & 1')
    end

    -- For a given control algorithm, see how the RMS changes with # of episodes for
    -- lambda = 0 and lambda = 1.
    function AA:eval_l0_l1_rms(
            Sarsa,
            image_fname,
            n_iters)
        self.Q_mc = self.Q_mc or self:get_true_q()
        n_iters = n_iters or self.n_iters
        local function get_rms_episode_data(lambda)
            local rms_episode_data = torch.Tensor(n_iters/self.rms_plot_freq, 2)
            sarsa = Sarsa(lambda, self.env)
            local Q = sarsa:improve():get_Q()
            rms_episode_data[1][1] = 1
            rms_episode_data[1][2] = qva.q_rms(Q, self.Q_mc)
            for i = 2, (#rms_episode_data)[1] do
                for j = 1, self.rms_plot_freq do
                    sarsa:improve()
                end
                Q = sarsa:get_Q()
                rms_episode_data[i][1] = i
                rms_episode_data[i][2] = qva.q_rms(Q, self.Q_mc)
            end
            return rms_episode_data
        end

        print('Generating data/plots for RMS vs episode')
        local l0_data = get_rms_episode_data(0)
        local l1_data = get_rms_episode_data(1)
        data = {}
        data[0] = l0_data
        data[1] = l1_data
        if self.show then
            gnuplot.figure()
            plot_rms_episode_data(data)
        end
        if self.save then
            print('Saving lambda=0/1 plot to: ' .. image_fname)
            gnuplot.epsfigure(image_fname)
            plot_rms_episode_data(data)
            gnuplot.plotflush()
        end
    end
end

M.AlgoAnalyzer = AlgoAnalyzer

return M
