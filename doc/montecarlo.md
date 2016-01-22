## Monte Carlo Control
Monte Carlo (MC) estimates the value of a state-action pair under a given
policy by sampling and taking the average. MC Control alternates between this
Q-function estimation and epsilon-greedy policy improvement.

Example use:

```lua
local mdp = TestMdp()
local discount_factor = 0.9
local n_iters = 1000

local mdp_config = MdpConfig(mdp, discount_factor)
local mc = MonteCarloControl(mdp_config)
mc:improve_policy_for_n_iters(n_iters)

local policy = mc:get_policy()
local learned_action = policy.get_action(state)
```

