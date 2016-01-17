require 'Policy'
local GreedyPolicy, parent = torch.class('GreedyPolicy', 'Policy')

function GreedyPolicy:__init(Q, exploration_strat, actions)
    parent.__init(self)
    self.Q = Q
    self.exploration_strat = exploration_strat
    self.actions = actions
    self.n_actions = #actions
end

function GreedyPolicy:get_action(s)
    local eps = self.exploration_strat:get_eps(s)

    pi = {}
    for k, a in pairs(self.actions) do
        pi[a] = eps / self.n_actions
    end

    -- Add 1-eps to best action
    best_a = self.Q:get_best_action(s)
    pi[best_a] = pi[best_a] + 1 - eps

    return util.weighted_random_choice(pi)
end
