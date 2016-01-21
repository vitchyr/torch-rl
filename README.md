# torch-rl
This is a Torch 7 package the implements a few reinforcement learning
algorithms. So far, we've only implemented Q-learning.

This documentation is intended to mostly to give a high-level idea of what each
abstract class does. We start with a summary of the important files, and then
give a slightly more detailed description afterwards. For more detail, see the
source code. For examples on how to use the functions, see the unit tests.

## Summary of files
### Interfaces/abstract classes
* `Control.lua` - Represents an algorithm that improves a policy.
* `Mdp.lua` - A Markov Decision Proccess that represents an environemtn.
* `Policy.lua` - A way of deciding what action to do given a state.
* `Sarsa.lua` - A specific Control algorithm. Technically, it's Sarsa(lambda)
* `SAFeatureExtractor.lua` - Represents a way of extracting features from a given
  [S]tate-[A]ction pair.
* `ControlFactory.lua` - Used to create new Control instances
* `Explorer.lua` - Used to get the epsilon value for EpsilonGreedy

### Concrete classes
* `Evaluator.lua` - Used to measure the performance of a policy
* `MdpConfig.lua` - A way of configuring an Mdp.
* `MdpSampler.lua` - A useful wrapper around an Mdp.
* `QVAnalyzer.lua` - Used to get measurements out of Control algorithms

### Specific implementations
* `EpsilonGreedyPolicy.lua` - Implements epsilon greedy policy.
* `DecayTableExplorer.lua` - A way of decaying epsilon for epsilon greedy policy
  to ensure convergence.
* `NNSarsa.lua` - Implements Sarsa(lambda) using neural networks as a function
  approximator
* `LinSarsa.lua` - Implements Sarsa(lambda) using linear weighting as a function
  approximator
* `TableSarsa.lua` - Implements Sarsa(lambda) using a lookup table.
* `MonteCarloControl.lua` - Implements Monte Carlo control.

### Test Files
* `unittest\_\*.lua` - Unit tests. Can be run directly with `th
unittest\_\*.lua`.
* `run\_rl\_unittests.lua` - Run all unit tests related to this package.
* `run\_easy21\_unittests.lua` - Run all unit tests related to the Easy21 MDP.
* `run\_all\_unittests.lua` - Run all unit tests in this package.
* `TestMdp.lua` - An MDP used for testing.
* `TestPolicy.lua` - A policy for TestMdp used for testing.
* `TestSAFE.lua` - A feature extractor used for testing.

### Easy 21
Easy21 is an example MDP that gives you an idea of how to implement a non-trival
MDP, and corresponding files.

## A note on Abstract Classes/Interfaces
Torch doesn't implement interfaces nor abstract classes natively, but this
packages tries to implement them by defining functions and raising an error if
you try to implement it. (We'll call everything an abstract class
just for simplicity.)

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

## Policy
A Policy implements one method:

`[action] get_action(state)`

### EpsilonGreedyPolicy
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

### DecayTableExplorer
This type of explorer chooses epislon to be

`N0 / (N0 + N(s)`

where `N0` is some constant, and `N(s)` is the number of times state `s` has
been visited. This type of exploration strategy with EpsilonGreedyPolicy is
guaranteed to converge to the optimal policy since each state is explored, but
eventually the best action is exploited. This is because as the number of times
states has been visited explored (i.e. the more exploration we've done) the
smaller epsilon because (i.e. don't bother exploring as much).

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
Documentation is a TODO - see LinSarsa.lua for now.

### Neural Network Approximation
Documentation is a TODO - see NNSarsa.lua for now.

