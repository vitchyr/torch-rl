require 'Policy'
local GreedyPolicy, parent = torch.class('GreedyPolicy', 'Policy')

function GreedyPolicy:__init(Q, exploration_strat)
    parent.__init(self)
    self.Q = Q
    self.exploration_strat = exploration_strat
end

function GreedyPolicy:get_action(s)
    local eps = self.exploration_strat.get_eps()

    actions = env.get_all_actions()
    n_actions = #actions
    pi = {}
    for k, a in pairs(actions) do
        pi[a] = eps / n_actions
    end

    -- Add 1-eps to best action
    best_a = Q:get_best_action(s)
    pi[best_a] = pi[best_a] + 1 - eps

    return util.weighted_random_choice(pi)
end
