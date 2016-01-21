# torch-rl
This is a Torch 7 package the implements a few reinforcement learning
algorithms. So far, we've only implemented Q-learning.

## A note on Abstract Classes/Interfaces
Torch doesn't implement interfaces nor abstract classes natively, but this
packages tries to implement them by defining functions and raising an error if
you try to implement it. (We'll call everything an abstract class
just for simplicity.)

This documentation is intended to mostly to give a high-level idea of what each
abstract class does. For details on what functions are exported, see the source
code. For better examples on how to use the functions, see the unit tests.

## Markov Decision Proccess (MDP)
Markov Decision Proccesses (MDPs) are at the heard of the RL algorithms
implemented. Here, they are represented as a class.  The definition of the MDP
class will depend on the particular problem.

The MDP must implement two methods:

`[next_state, reward] step(s, a)`
    given a state and action, returns the next state and reward for taking
    that action.

`[boolean] is_terminal(s)`
    returns if a state is terminal

### MDP Config
Most other classes will require a `MdpConfig` instance. `MdpConfig` is a data
structure that contains an MDP and configuration, such as the discount factor. A
common pattern is the following:

```
local mdp = TestMdp()
local discount_factor = 0.9

local mdp_config = MdpConfig(mdp, discount_factor)
--- use mdp_config for future calls
```

### MdpSampler
The MdpSampler is responsible for 'playing' out an episode of the MDP. It must
be given an MDP and implements two methods:

`[number] sample_reward(policy)`
    Samples the reward of a given policy.

`[episode] get_episode(policy)`
    Return an episode by following the trajectory of a given policy.

An episode is a table of {state, action, discounted return, reward}, indexed by
time. Time starts at 1 (going along with Lua conventions).

## Policy
A Policy implements one method:

`[action] get_action(state)`

### EpsilonGreedy Policy - Concrete class
The EpsilonGreedy policy is a simply policy that balances exploration and
exploitation. The idea of epsilon greedy policies is to choose a random action
with some small probability (epsilon). This encourages exploration. Otherwise,
choose the best action, to exploit our knowledge so far.

This is currently the only non-trivial policy implemented.

### Explorer
This is used to choose how to balance exploration vs. exploitation.
Specifically, it gives the probablity of exploring. So, it implements

`[number from 0 to 1] get_eps(s)`

which returns epsilon for the epsilon greedy policy.

## Value Functions
All Q value functions implement:
    `get_value(s, a)`

    `get_best_action(s)`

All V value functions implement:
    `get_value(s)`

### (Hash)Tables
These are the simplest types of data structures. SHash and SAHash implement hash
tables over the state and state-action states space, respectively. Only use
these hash tables for small state/action spaces.

### Function Approximation
For large state/action spaces, using a look-up table becomes intractable. An
alternative is to approximate the value of a state or state-action pair by using
a function approximator. See below for how features are extracted.

## State-Action Feature Extractors (SAFE)
SAFeatureExtractor defines an interface for classes that extract features out of
a given state-action pair. SAFEs have to implement:

`[Tensor] get_sa_features(s, a)`
`[number of tuple of numbers] get_sa_features_dim()`
which returns the dimensions of the tensor returned by `get_sa_features`.

## Control Algorithms
The `Control` interface captures algorithms are used to improve policies/Q
functions.

### Monte Carlo Control
Monte Carlo (MC) estimates the value of a state-action pair under a given
policy by sampling and taking the average. MC Control alternates between this
Q-function estimation and epsilon-greedy policy improvement.

Example use:

```
local mdp = TestMdp()
local discount_factor = 0.9
local n_iters = 1000

local mdp_config = MdpConfig(mdp, discount_factor)
local mc = MonteCarloControl(mdp_config)
mc:improve_policy_for_n_iters(n_iters)

local policy = mc:get_policy()
local learned_action = policy.get_action(state)
```

### Sarsa(lambda)
See [Sutton and
Barto](https://webdocs.cs.ualberta.ca/~sutton/book/ebook/node77.html) for
explanation of algorithm. One major difference is that we used discounted
reward.

The main step that is abstracted away is how Q(s, a) is updated given the TD
error. The underlying structure of Q (e.g. hash table vs. function approximator)
will determine how it is handled. The eligibility update will also change base
on the structure.

Three versions are implemented:
* TableSarsa - Use lookup tables to store Q
* LinSarsa - Use a linear dot product of features to approximate Q
* NnSarsa - Use a neural network to approximate Q

### Linear Approximation
Documentation is TODO - see LinSarsa for now.

### Neural Network Approximation
TODO - see NNSarsa for now.
