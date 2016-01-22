local Mdp = torch.class('Mdp')

function Mdp:__init()
end

function Mdp:step(state, action)
    error('Must implement step')
end

function Mdp:get_start_state()
    error('Must implement get_start_state')
end

function Mdp:is_terminal(state)
    error('Must implement is_terminal')
end

-- The next two functions shoul return all states/actions in a list (i.e. a
-- Table with numbers as keys). These two methods might be really expensive to
-- compute. It's the responsibility of the caller to take that into
-- consideration.
function Mdp:get_all_states()
    error('Must implement get_all_states')
end

function Mdp:get_all_actions()
    error('Must implement get_all_actions')
end

-- These hash functions for the state and action are used if you plan on using
-- TableSarsa. Otherwise, use feature extractors.
--
-- TODO: Move this to its own class, like SAFeatureExtractor.
function Mdp:hash_s(state)
    error('Must implement hash_s')
end

function Mdp:hash_a(action)
    error('Must implement hash_a')
end

function Mdp:get_description()
    return 'Base MDP'
end
