local GeneralizedPolicyIteration = torch.class("GeneralizedPolicyIteration")

-- GeneralizedPolicyIteration captures an algorithm that optimizes a policy by alternating between
-- policy evaluation and policy iteration
function GeneralizedPolicyIteration:__init(env, policy)
    self.env = env
    self:set_policy(policy)
    self:initialize_params()
end

function GeneralizedPolicyIteration:improve_policy_for_n_iters(n_iters, policy)
    for i = 1, n_iters do
        self:improve_policy()
        self:evaluate_policy()
    end
end

function GeneralizedPolicyIteration:set_policy(policy)
    self.policy = policy
end

function GeneralizedPolicyIteration:get_policy()
    return self.policy
end

function GeneralizedPolicyIteration:initialize_params()
end

function GeneralizedPolicyIteration:improve_policy()
    error('Must implement improve_policy.')
end

function GeneralizedPolicyIteration:evaluate_policy()
    error('Must implement evaluate_policy.')
end
