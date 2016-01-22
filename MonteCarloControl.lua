require 'ValueIteration'
require 'MdpSampler'
require 'constants'
require 'DecayTableExplorer'
require 'QHash'
require 'VHash'

local MonteControl, parent =
    torch.class('MonteCarloControl', 'ValueIteration')

function MonteCarloControl:__init(mdp_config)
    parent.__init(self, mdp_config)
    self.q = QHash(self.mdp)
    self.Ns = VHash(self.mdp)
    self.Nsa = QHash(self.mdp)
    self.N0 = N0
    self.actions = self.mdp.get_all_actions()
end

function MonteCarloControl:optimize_policy()
    self.policy = rl.GreedyPolicy(
        self.q,
        DecayTableExplorer(self.N0, self.Ns),
        self.actions
    )
end

function MonteCarloControl:evaluate_policy()
    local episode = self.sampler:get_episode(self.policy)
    for t, data in pairs(episode) do
        local s = data.state
        local a = data.action
        local Gt = data.discounted_return

        self.Ns:add(s, 1)
        self.Nsa:add(s, a, 1)

        local alpha = 1. / self.Nsa:get_value(s, a)
        self.q:add(s, a, alpha * (Gt - self.q:get_value(s, a)))
    end
end

function MonteCarloControl:get_q()
    return self.q
end

function MonteCarloControl:__eq(other)
    return torch.typename(self) == torch.typename(other)
        and self.q == other.q
        and self.Ns == other.Ns
        and self.Nsa == other.Nsa
        and self.N0 == other.N0
end
