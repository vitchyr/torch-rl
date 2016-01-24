require 'rl'
require 'BlackJack_constants'

local BlackJack, parent = torch.class('BlackJack', 'rl.Mdp')

local function draw()
    local v = math.random(1,10)
    if math.random() <= RED_PROB then
        v = -v
    end
    return v
end

local function draw_black()
    return math.random(1,10)
end

local function is_bust(sum)
    return sum < 1 or sum > 21
end

function BlackJack:__init(dealer_limit)
    parent.__init(self)
    self.dealer_limit = dealer_limit or DEFAULT_DEALER_LIMIT
end

--[[
-- Take a step in the game
--   s: state, a table of {dealer_sum, player_sum}
--   a: action
--]]
function BlackJack:step(state, action)
    if state == TERMINAL then 
        print('Game is already over')
        return TERMINAL, 0
    end

    local dealer_sum, player_sum = table.unpack(state)

    if action == HIT then
        player_sum = player_sum + draw()
        if is_bust(player_sum) then
            return TERMINAL, -1
        end
        return {dealer_sum, player_sum}, 0
    end

    -- At this point, the player hit
    while dealer_sum < self.dealer_limit do
        dealer_sum = dealer_sum + draw()
        if is_bust(dealer_sum) then
            return TERMINAL, 1
        end
    end

    local r = 0 -- for a draw, r should be 0
    if player_sum > dealer_sum then
        r = 1
    elseif player_sum < dealer_sum then
        r = -1
    end

    return TERMINAL, r
end

function BlackJack:get_start_state()
    return {draw_black(), draw_black()}
end

function BlackJack:is_terminal(s)
    return s == TERMINAL
end

function BlackJack:get_all_states()
    states = {}
    for dealer = 1, 10 do
        for player = 1, 21 do
            table.insert(states, {dealer, player})
        end
    end
    return states
end

function BlackJack:get_all_actions()
    return {HIT, STICK}
end

function BlackJack:hash_s(s)
    local dealer_sum, player_sum = table.unpack(s)
    return (9+dealer_sum) + 41*(9+player_sum)
end

function BlackJack:hash_a(a)
    return a -- use the fact that actions are numbers right now
end

function BlackJack:get_description()
    return 'Simplified Black Jack'
end

return M
