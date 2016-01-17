require 'Mdp'
require 'constants'
local util = require 'util'

local Easy21, parent = torch.class('Easy21', 'Mdp')

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

--[[
-- Take a step in the game
--   s: state, a table of {dealer_sum, player_sum}
--   a: action
--]]
function Easy21:step(s, a)
    if s == TERMINAL then 
        print('Game is already over')
        return TERMINAL, 0
    end

    local dealer_sum, player_sum = table.unpack(s)

    if a == HIT then
        player_sum = player_sum + draw()
        if is_bust(player_sum) then
            return TERMINAL, -1
        end
        return {dealer_sum, player_sum}, 0
    end

    -- At this point, the player hit
    while dealer_sum < 17 do
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

function Easy21:get_start_state()
    return {draw_black(), draw_black()}
end

function Easy21:get_all_states()
    states = {}
    for dealer = 1, 10 do
        for player = 1, 21 do
            table.insert(states, {dealer, player})
        end
    end
    return states
end
--Easy21:get_all_states = util.memoize(_get_all_states) <-- this doesn't really help

function Easy21:get_all_actions()
    return {HIT, STICK}
end

function Easy21:hash_s(s)
    local dealer_sum, player_sum = table.unpack(s)
    return (9+dealer_sum) + 41*(9+player_sum)
end

function Easy21:hash_a(a)
    return a -- use the fact that actions are numbers right now
end

function Easy21:copy_state(s)
    return util.copy_simply(s)
end

function Easy21:is_terminal(s)
    return s == TERMINAL
end

function Easy21:get_description()
    return 'Easy 21'
end

return M
