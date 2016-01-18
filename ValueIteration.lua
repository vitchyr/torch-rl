require 'Control'

local ValueIteration = torch.class('ValueIteration', 'Control')

-- ValueIteration captures an algorithm that optimizes a policy by alternating
-- between policy evaluation for one step and policy iteration for one step
function ValueIteration:improve_policy()
    self:optimize_policy()
    self:evaluate_policy()
end

function ValueIteration:optimize_policy()
    error('Must implement optimize_policy.')
end

function ValueIteration:evaluate_policy()
    error('Must implement evaluate_policy.')
end
