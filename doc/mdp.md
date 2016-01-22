## Markov Decision Proccess (MDP)
Markov Decision Proccesses (MDPs) are at the heard of the RL algorithms
implemented. Here, they are represented as a class. The definition of the MDP
class will depend on the particular problem.

The biggest idea of MDPs is that they are memoryless. The state of an MDP should
be enough to determine what happens next.

### MDP Config
Most other classes will require a `MdpConfig` instance instead of a `Mdp`
instance. `MdpConfig` is a wrapper data structure that contains an MDP and
configuration, such as the discount factor. A common pattern is the following:

```lua
local mdp = TestMdp()
local discount_factor = 0.9

local mdp_config = MdpConfig(mdp, discount_factor)
--- use mdp_config for future calls
```

### MdpSampler
The MdpSampler is a wrapper around an Mdp that out provides some convenience
methods for sampling the MDP, namely:

* `[number] sample_reward(policy)`
* `[episode] get_episode(policy)`

An episode is a table of {state, action, discounted return, reward}, indexed by
time. Time starts at 1 (going along with Lua conventions).

<a name="create_mdp"></a>
### Creating Your Own MDP
To create a MDP, extend the base MDP class using torch:

```
require 'Mdp'
local MyMdp, parent = torch.class('MyMdp', 'Mdp')

function MyMdp:__init(arg1)
    parent.__init(self)
end
```

The main functions that an MDP needs to be implemented are

* `[next_state, reward] step(state, action)` Note that state should capture
everything needed to compute the next state and reward, given an action.
* `[state] get_start_state()`
* `[boolean] is_terminal(state)`

Check out [Mdp.lua](../Mdp.lua) for detail on other the functions that you may
want to implement. See [Blackjack.lua](../BlackJack.lua) for an example.

