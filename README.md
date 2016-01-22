# torch-rl
This is a Torch 7 package that implements a few reinforcement learning
algorithms. So far, we've only implemented Q-learning.

This documentation is intended to mostly to give a high-level idea of what each
abstract class does. We start with a summary of the important files, and then
give a slightly more detailed description afterwards. For more detail, see the
source code. For examples on how to use the functions, see the unit tests.

## Summary of files
Files that start with upper cases are classes. Every other file is a script,
except for the constants and util file.

### Interfaces/abstract classes
* `Control.lua` - Represents an algorithm that improves a policy.
* `Mdp.lua` - A Markov Decision Proccess that represents an environemtn.
* `Policy.lua` - A way of deciding what action to do given a state.
* `Sarsa.lua` - A specific Control algorithm. Technically, it's Sarsa-lambda
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
* `NNSarsa.lua` - Implements Sarsa-lambda using neural networks as a function
  approximator
* `LinSarsa.lua` - Implements Sarsa-lambda using linear weighting as a function
  approximator
* `TableSarsa.lua` - Implements Sarsa-lambda using a lookup table.
* `MonteCarloControl.lua` - Implements Monte Carlo control.

### Test Files
* `unittest_*.lua` - Unit tests. Can be run directly with `th
unittest_*.lua`.
* `run_rl_unittests.lua` - Run all unit tests related to this package.
* `run_BlackJack_unittests.lua` - Run all unit tests related to Black Jack.
* `run_all_unittests.lua` - Run all unit tests in this package.
* `TestMdp.lua` - An MDP used for testing.
* `TestPolicy.lua` - A policy for TestMdp used for testing.
* `TestSAFE.lua` - A feature extractor used for testing.

## Read More
* [MDP](doc/mdp.md) - Read about Markov Decision Processes, which are the
  foundation of how reinforcement learning models the world.
* [Policy](doc/policy.md) - Policies are mappings from state to action.
* [Black Jack](doc/blackjack.md) - An example MDP that is a simplified version
  of black jack.
* [Sarsa](doc/sarsa.md) - Read about the Sarsa-lambda algorithm and scripts that
  test them.
* [Monte Carlo Control](doc/montecarlo.md) - Read about Monte Carlo Control and
  how to use it.
* [Value Functions](doc/valuefunctions.md) - Value functions represent how
  valuable certains states and/or actions are.

## A note on Abstract Classes/Interfaces
Torch doesn't implement interfaces nor abstract classes natively, but this
packages tries to implement them by defining functions and raising an error if
you try to implement it. (We'll call everything an abstract class
just for simplicity.)
