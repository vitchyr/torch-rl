local ufu = require 'util_for_unittests'

local tester = torch.Tester()

local TestTableSarsa = {}
local discount_factor = 0.9
local mdp = rl.TestMdp()
local mdp_config = rl.MdpConfig(mdp, discount_factor)

local function non_q_params_match(
        sarsa,
        Ns_expected,
        Nsa_expected,
        eligibility_expected)
    local Ns = sarsa.Ns
    local Nsa = sarsa.Nsa
    local elig = sarsa.eligibility

    return ufu.do_vtable_vfunc_match(mdp, Ns_expected, Ns)
        and ufu.do_qtable_qfunc_match(mdp, Nsa_expected, Nsa)
        and ufu.do_qtable_qfunc_match(mdp, eligibility_expected, elig)
end

function TestTableSarsa.test_update_eligibility_one_step()
    local lambda = 1
    local sarsa = rl.TableSarsa(mdp_config, lambda)

    local s = 2
    local a = 1
    sarsa:update_eligibility(s, a)

    local Ns_expected = {0, 1, 0}
    local Nsa_expected = { -- row = state, colm = action
        [1] = {0, 0, 0},
        [2] = {1, 0, 0},
        [3] = {0, 0, 0}
    }
    local eligibility_expected = Nsa_expected
    local correct = non_q_params_match(
        sarsa,
        Ns_expected,
        Nsa_expected,
        eligibility_expected)
    tester:assert(correct)
end

function TestTableSarsa.test_update_eligibility_lambda1()
    local lambda = 1
    local sarsa = rl.TableSarsa(mdp_config, lambda)

    local s = 2
    local a = 1
    sarsa:update_eligibility(s, a)

    local Ns_expected = {
        [1] = 0,
        [2] = 1,
        [3] = 0,
    }
    local Nsa_expected = { -- row = state, colm = action
        [1] = {0, 0, 0},
        [2] = {1, 0, 0},
        [3] = {0, 0, 0}
    }
    local eligibility_expected = Nsa_expected
    local correct = non_q_params_match(
        sarsa,
        Ns_expected,
        Nsa_expected,
        eligibility_expected)
    tester:assert(correct)
end

function TestTableSarsa:test_update_eligibility_lambda_frac()
    local lambda = 0.5
    local sarsa = rl.TableSarsa(mdp_config, lambda)

    local s = 2
    local a = 1
    sarsa:update_eligibility(s, a)
    sarsa:update_eligibility(s, a)
    sarsa:update_eligibility(s, a)

    local decay_factor = lambda * discount_factor

    local Ns_expected = {0, 3, 0}
    local Nsa_expected = { -- row = state, colm = action
        [1] = {0, 0, 0},
        [2] = {3, 0, 0},
        [3] = {0, 0, 0}
    }
    local eligibility_expected = {
        [1] = {0, 0, 0},
        [2] = {1 + decay_factor * (1 + decay_factor*1), 0, 0},
        [3] = {0, 0, 0}
    }
    local correct = non_q_params_match(
        sarsa,
        Ns_expected,
        Nsa_expected,
        eligibility_expected)
    tester:assert(correct)
end

function TestTableSarsa:test_update_eligibility_lambda0()
    local lambda = 0
    local sarsa = rl.TableSarsa(mdp_config, lambda)

    local s = 2
    local a = 1
    sarsa:update_eligibility(s, a)
    sarsa:update_eligibility(s, a)
    sarsa:update_eligibility(s, a)

    local decay_factor = lambda * discount_factor

    local Ns_expected = {0, 3, 0}
    local Nsa_expected = { -- row = state, colm = action
        [1] = {0, 0, 0},
        [2] = {3, 0, 0},
        [3] = {0, 0, 0}
    }
    local eligibility_expected = {
        [1] = {0, 0, 0},
        [2] = {1 + decay_factor * (1 + decay_factor*1), 0, 0},
        [3] = {0, 0, 0}
    }
    local correct = non_q_params_match(
        sarsa,
        Ns_expected,
        Nsa_expected,
        eligibility_expected)
    tester:assert(correct)
end

function TestTableSarsa:test_update_eligibility_mixed_updates()
    local lambda = 0.4
    local sarsa = rl.TableSarsa(mdp_config, lambda)

    local s = 2
    local a = 1
    sarsa:update_eligibility(s, a)
    s = 1
    a = 2
    sarsa:update_eligibility(s, a)
    s = 2
    a = 3
    sarsa:update_eligibility(s, a)

    local decay_factor = lambda * discount_factor

    local Ns_expected = {1, 2, 0}
    local Nsa_expected = { -- row = state, colm = action
        [1] = {0, 1, 0},
        [2] = {1, 0, 1},
        [3] = {0, 0, 0}
    }
    local eligibility_expected = {
        [1] = {0, decay_factor, 0},
        [2] = {decay_factor^2, 0, 1},
        [3] = {0, 0, 0}
    }
    local correct = non_q_params_match(
        sarsa,
        Ns_expected,
        Nsa_expected,
        eligibility_expected)
    tester:assert(correct)
end

function TestTableSarsa:test_td_update_one_update()
    local lambda = 0.4
    local sarsa = rl.TableSarsa(mdp_config, lambda)

    local s = 2
    local a = 1
    sarsa:update_eligibility(s, a)
    local td_error = 5
    sarsa:td_update(td_error)
    local q_expected = { -- row = state, colm = action
        [1] = {0, 0, 0},
        [2] = {5, 0, 0},
        [3] = {0, 0, 0}
    }
    tester:assert(ufu.do_qtable_qfunc_match(mdp, q_expected, sarsa.q))
end

function TestTableSarsa:test_td_update_many_updates()
    local lambda = 0.4
    local sarsa = rl.TableSarsa(mdp_config, lambda)

    local s = 2
    local a = 1
    sarsa:update_eligibility(s, a)
    local td_error = 5
    sarsa:td_update(td_error)
    sarsa:update_eligibility(s, a)
    sarsa:td_update(td_error)

    s = 3
    a = 3
    sarsa:update_eligibility(s, a)
    td_error = -10
    sarsa:td_update(td_error)

    local decay_factor = lambda * discount_factor
    local q_expected = { -- row = state, colm = action
        [1] = {0, 0, 0},
        [2] = {5+5*(1+decay_factor)/2-10*decay_factor*(1+decay_factor)/2, 0, 0},
        [3] = {0, 0, -10}
    }
    tester:assert(ufu.do_qtable_qfunc_match(mdp, q_expected, sarsa.q))
end

tester:add(TestTableSarsa)

tester:run()

