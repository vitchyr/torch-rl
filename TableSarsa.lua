-- Implement SARSA algorithm using a linear function approximator for on-line
-- policy control
local TableSarsa, parent = torch.class('rl.TableSarsa', 'rl.Sarsa')
function TableSarsa:__init(mdp_config, lambda)
    parent.__init(self, mdp_config, lambda)
    self.Ns = rl.VHash(self.mdp)
    self.Nsa = rl.QHash(self.mdp)
    self.q = rl.QHash(self.mdp)
    self.eligibility = rl.QHash(self.mdp)
end

function TableSarsa:get_new_q()
    return rl.QHash(self.mdp)
end

function TableSarsa:reset_eligibility()
    self.eligibility = rl.QHash(self.mdp)
end

function TableSarsa:update_eligibility(s, a)
    for _, state in pairs(self.mdp:get_all_states()) do
        for _, action in pairs(self.mdp:get_all_actions()) do
            self.eligibility:mult(
                state,
                action,
                self.discount_factor*self.lambda)
        end
    end
    self.eligibility:add(s, a, 1)
    self.Ns:add(s, 1)
    self.Nsa:add(s, a, 1)
end

local function get_step_size(self, state, action)
    local value = self.Nsa:get_value(state, action)
    if value == 0 then
        return value
    end
    return 1. / value
end

function TableSarsa:td_update(td_error)
    for _, state in pairs(self.mdp:get_all_states()) do
        for _, action in pairs(self.mdp:get_all_actions()) do
            local step_size = get_step_size(self, state, action)
            local eligibility = self.eligibility:get_value(state, action)
            self.q:add(
                state,
                action,
                step_size * td_error * eligibility)
        end
    end
end

function TableSarsa:update_policy()
    self.explorer = rl.DecayTableExplorer(
        rl.MONTECARLOCONTROL_DEFAULT_N0,
        self.Ns)
    self.policy = rl.GreedyPolicy(
        self.q,
        self.explorer,
        self.actions
    )
end

function TableSarsa:__eq(other)
    return torch.typename(self) == torch.typename(other)
        and self.Ns == other.Ns
        and self.Nsa == other.Nsa
        and self.q == other.q
        and self.eligibility == other.eligibility
end
