require 'rl'
-- Episode: list of {state, action, discounted return, reward}, indexed by time.
-- Time starts at 1 (going along with Lua conventions).
-- This class builds this list intelligentally based on discount_factor, the discount
-- factor.
local EpisodeBuilder = torch.class('rl.EpisodeBuilder')

function EpisodeBuilder:__init(discount_factor)
    if discount_factor < 0 or discount_factor > 1 then
        error('Gamma must be between 0 and 1, inclusive.')
    end
    self.t = 1
    self.episode = {}
    self.discount_factor = discount_factor
    self.built = false
end

function EpisodeBuilder:add_state_action_reward_step(state, action, reward)
    self.episode[self.t] = {
        state = state,
        action = action,
        discounted_return = reward,
        reward = reward
    }
    self.t = self.t + 1
    self.built = false
end

local function is_built(self)
    return self.discount_factor == 0 or self.built
end

function EpisodeBuilder:get_episode()
    if is_built(self) then
        return self.episode
    end

    local t = self.t - 1
    local discounted_future_return = self.discount_factor * self.episode[t].reward
    t = t - 1
    for i = 1, #self.episode - 1 do
        self.episode[t].discounted_return = self.episode[t].discounted_return +
                                            discounted_future_return
        discounted_future_return = self.discount_factor * (discounted_future_return +
                                                 self.episode[t].reward)
        t = t - 1
    end
    self.built = true
    return self.episode
end
