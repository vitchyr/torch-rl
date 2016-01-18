local ValueIteration = torch.class("ValueIteration")

-- ValueIteration captures an algorithm that optimizes a policy by alternating between
-- policy evaluation and policy iteration
function ValueIteration:__init(mdp_config, policy)
    self.mdp = mdp_config:get_mdp()
    self:set_policy(policy)
    self.sampler = MdpSampler(mdp_config)
end

function ValueIteration:improve_policy_for_n_iters(n_iters, policy)
    for i = 1, n_iters do
        self:improve_policy()
        self:evaluate_policy()
    end
end

function ValueIteration:set_policy(policy)
    self.policy = policy
end

function ValueIteration:get_policy()
    return self.policy
end

function ValueIteration:improve_policy()
    error('Must implement improve_policy.')
end

function ValueIteration:evaluate_policy()
    error('Must implement evaluate_policy.')
end
