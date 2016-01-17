require 'GeneralizedPolicyIteration'

local MonteControl, parent =
    torch.class('MonteCarloControl', 'GeneralizedPolicyIteration')

function MonteCarloControl:initialize_params()
end

function MonteCarloControl:improve_policy()
    error('Must implement improve_policy.')
end

function MonteCarloControl:evaluate_policy()
    error('Must implement evaluate_policy.')
end


