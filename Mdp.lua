local Mdp = torch.class('Mdp')

function Mdp:__init()
end

function Mdp:step(s, a)
    error('Must implement step')
end

function Mdp:get_start_state()
    error('Must implement get_start_state')
end

function Mdp:get_all_states()
    error('Must implement get_all_states')
end

function Mdp:get_all_actions()
    error('Must implement get_all_actions')
end

function Mdp:hash_s(s)
    error('Must implement hash_s')
end

function Mdp:hash_a(a)
    error('Must implement hash_a')
end

function Mdp:copy_state(s)
    error('Must implement is_terminal')
end

function Mdp:is_terminal(s)
    error('Must implement is_terminal')
end

function Mdp:get_description()
    return 'Base MDP'
end
