-- Episode: list of {state, action, discounted return, reward}, indexed by time.
-- Time starts at 1 (going along with Lua conventions).
-- This class builds this list intelligentally based on gamma, the discount
-- factor.
local EpisodeBuilder = torch.class('EpisodeBuilder')

-- gamma: discount factor
function EpisodeBuilder:__init(gamma)
    if gamma < 0 or gamma > 1 then
        error('Gamma must be between 0 and 1, inclusive.')
    end
    self.t = 1
    self.episode = {}
    self.gamma = gamma
end

function EpisodeBuilder:add_state_action_reward_step(state, action, reward)
    self.episode[self.t] = {
        state = state,
        action = action,
        discounted_return = reward,
        reward = reward
    }
    self.t = self.t + 1
end

function EpisodeBuilder:get_episode()
    if self.gamma == 0 then
        return self.episode
    end

    local t_from_back = self.t - 1
    local discounted_future_return = self.gamma * self.episode[t_from_back].reward
    t_from_back = t_from_back - 1
    for i = 1, #self.episode - 1 do
        self.episode[t_from_back].discounted_return = 
            self.episode[t_from_back].discounted_return +
            discounted_future_return
        discounted_future_return = self.gamma * (discounted_future_return +
                                    self.episode[t_from_back].reward)
        t_from_back = t_from_back - 1
    end
    return self.episode
end
