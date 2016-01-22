require 'MdpSampler'

local Control = torch.class("Control")

-- Control captures an algorithm that optimizes a policy for a given MDP.
function Control:__init(mdp_config)
    self.mdp = mdp_config:get_mdp()
    self.policy = rl.AllActionsEqualPolicy(self.mdp)
    self.sampler = MdpSampler(mdp_config)
end

function Control:improve_policy_for_n_iters(n_iters)
    for i = 1, n_iters do
        self:improve_policy()
    end
end

function Control:improve_policy()
    error('Must implement improve_policy')
end

function Control:set_policy(policy)
    self.policy = policy
end

function Control:get_policy()
    return self.policy
end

