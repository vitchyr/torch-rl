require 'constants'
require 'Easy21'
require 'QVAnalyzer'
local Easy21QVAnalyzer, parent = torch.class('Easy21QVAnalyzer', 'QVAnalyzer')

function Easy21QVAnalyzer:__init()
    parent.__init(self, Easy21())
end

function Easy21QVAnalyzer:get_v_tensor(v)
    local tensor = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES)
    for dealer = 1, N_DEALER_STATES do
        for player = 1, N_PLAYER_STATES do
            s = {dealer, player}
            tensor[s] = v:get_value(s)
        end
    end
    return tensor
end

function Easy21QVAnalyzer:get_q_tensor(q)
    local tensor = torch.zeros(N_DEALER_STATES, N_PLAYER_STATES, N_ACTIONS)
    for dealer = 1, N_DEALER_STATES do
        for player = 1, N_PLAYER_STATES do
            for a = 1, N_ACTIONS do
                s = {dealer, player}
                tensor[s][a] = q:get_value(s, a)
            end
        end
    end
    return tensor
end

function Easy21QVAnalyzer:v_from_q(q)
    local v = VHash(self.env)
    for dealer = 1, N_DEALER_STATES do
        for player = 1, N_PLAYER_STATES do
            local s = {dealer, player}
            local a = q:get_best_action(s)
            v:add(s, q:get_value(s, a))
        end
    end
    return v
end
