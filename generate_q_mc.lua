require 'rl'
local io_util = require 'io_util'
require 'constants'
require 'BlackJack'
require 'BlackJackQVAnalyzer'
require 'TestMdpQVAnalyzer'

-- Script for generating Q for Monte Carlo to save.
local cmd = torch.CmdLine()
cmd:option('-ni', 6, 'log_10(# of iterations)')
cmd:option('-saveqto', DEFAULT_Q_MC_SAVE, 'save Q to this file if provided')
local params = cmd:parse(arg)

local mdp = BlackJack()
local discount_factor = 1
local n_iters = 10^params.ni

local mdp_config = rl.MdpConfig(mdp, discount_factor)
local mc = rl.MonteCarloControl(mdp_config)
mc:improve_policy_for_n_iters(n_iters)

local q = mc:get_q()

io_util.save_q(params.saveqto, q)
