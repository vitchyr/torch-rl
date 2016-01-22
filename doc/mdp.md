## Markov Decision Proccess (MDP)
Markov Decision Proccesses (MDPs) are at the heard of the RL algorithms
implemented. Here, they are represented as a class. The definition of the MDP
class will depend on the particular problem.

### MDP Config
Most other classes will require a `MdpConfig` instance instead of a `Mdp`
instance. `MdpConfig` is a wrapper data structure that contains an MDP and
configuration, such as the discount factor. A common pattern is the following:

```
local mdp = TestMdp()
local discount_factor = 0.9

local mdp_config = MdpConfig(mdp, discount_factor)
--- use mdp_config for future calls
```

### MdpSampler
The MdpSampler is a wrapper around an Mdp that out provides some convenience
methods for sampling the MDP, namely:

`[number] sample_reward(policy)`
    Samples the reward of a given policy.

`[episode] get_episode(policy)`
    Return an episode by following the trajectory of a given policy.

An episode is a table of {state, action, discounted return, reward}, indexed by
time. Time starts at 1 (going along with Lua conventions).
