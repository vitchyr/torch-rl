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

-- Should return all states in a list (i.e. a Table with numbers as keys)
function Mdp:get_all_states()
    error('Must implement get_all_states')
end

function Mdp:get_all_actions()
    error('Must implement get_all_actions')
end

-- A hash function for the state.
function Mdp:hash_s(state)
    error('Must implement hash_s')
end

-- A hash function for the action.
function Mdp:hash_a(action)
    error('Must implement hash_a')
end

function Mdp:get_description()
    return 'Base MDP'
end
