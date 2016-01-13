local Explorer = torch.class('rl.Explorer')

function Explorer:__init()
end

--- Return epsilon, the probability of exploring randomly, given a state
function Explorer:get_eps(s)
    error('Explorer must implement get_eps')
end
