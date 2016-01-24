# torch-rl
This is a Torch 7 package that implements a few reinforcement learning (RL)
algorithms. So far, only Q-learning is implemented.

## Installation
#### Dependencies

0. (Optional)
   [LuaRocks](https://github.com/keplerproject/luarocks/wiki/Download)
 - Highly recommended for anyone who wants to use Lua. Also, install this before
   install Torch, as Torch has weird configurations for LuaRocks.
1. [Torch](http://torch.ch/docs/getting-started.html)
2. [Lua 5.1](http://www.lua.org/download.html) - Installing torch automatically
   installs Lua

#### LuaRocks - Automatic Installation (Recommended)

1. Install [LuaRocks](https://github.com/keplerproject/luarocks/wiki/Download).
2. From terminal, run
```
$ luarocks install rl
```

Error finding the module? Try
```
$ luarocks install --server=https://luarocks.org/ rl
```

#### LuaRocks - Manual Installation
1. `$ git clone git@github.com:vpong/torch-rl.git`
2. `$ luarocks make`

#### Totally Manually
```
$ git clone git@github.com:vpong/torch-rl.git
```
Note that you'll basically have to the files around to any project that you want
to use.

## Reinforcement Learning Topics
* [MDP](doc/mdp.md) - A Markov Decision Process (MDP) models the world. Read
  about useful MDP functions and [how to create your own
  MDP](doc/mdp.md#create_mdp).
* [Policy](doc/policy.md) - Policies are mappings from state to action.
* [Sarsa](doc/sarsa.md) - Read about the Sarsa-lambda algorithm and scripts that
  test them.
* [Monte Carlo Control](doc/montecarlo.md) - Read about Monte Carlo Control and
  how to use it.
* [Value Functions](doc/valuefunctions.md) - Value functions represent how
  valuable certains states and/or actions are.
* [Black Jack](https://github.com/vpong/rl-example) - An example repository that
  shows how to use RL algorithms to learn to play (a simplified version of)
  black jack.

## Summary of files
This gives a summary of the most important files. Files that start with upper
cases are classes. For more detail, see the source code. For examples on how to
use the functions, see the unit tests.

#### Interfaces/abstract classes
* `Control.lua` - Represents an algorithm that improves a policy.
* `Mdp.lua` - A Markov Decision Proccess that represents an environemtn.
* `Policy.lua` - A way of deciding what action to do given a state.
* `Sarsa.lua` - A specific Control algorithm. Technically, it's Sarsa-lambda
* `SAFeatureExtractor.lua` - Represents a way of extracting features from a given
  [S]tate-[A]ction pair.
* `ControlFactory.lua` - Used to create new Control instances
* `Explorer.lua` - Used to get the epsilon value for EpsilonGreedy

#### Concrete classes
* `Evaluator.lua` - Used to measure the performance of a policy
* `MdpConfig.lua` - A way of configuring an Mdp.
* `MdpSampler.lua` - A useful wrapper around an Mdp.
* `QVAnalyzer.lua` - Used to get measurements out of Control algorithms

#### Specific implementations
* `EpsilonGreedyPolicy.lua` - Implements epsilon greedy policy.
* `DecayTableExplorer.lua` - A way of decaying epsilon for epsilon greedy policy
  to ensure convergence.
* `NNSarsa.lua` - Implements Sarsa-lambda using neural networks as a function
  approximator
* `LinSarsa.lua` - Implements Sarsa-lambda using linear weighting as a function
  approximator
* `TableSarsa.lua` - Implements Sarsa-lambda using a lookup table.
* `MonteCarloControl.lua` - Implements Monte Carlo control.

#### Other Files
* `util/*.lua` - Utility functions used throughout the project.
* `test/unittest_*.lua` - Unit tests. Can be run individual tests with `th
unittest_*.lua`.
* `run_tests.lua` - Run all unit tests in `test/`directory.
* `TestMdp.lua` - An MDP used for testing.
* `TestPolicy.lua` - A policy for TestMdp used for testing.
* `TestSAFE.lua` - A feature extractor used for testing.

## A note on Abstract Classes and private methods
Torch doesn't implement interfaces nor abstract classes natively, but this
packages tries to implement them by defining functions and raising an error if
you try to implement it. (We'll call everything an abstract class
just for simplicity.)

Also, Torch classes don't provide a way of making private methods, so this is
faked with the following:

```lua

local function private_method(self, arg1, ...)
    ...
end

function Foo:bar()
    self:public_method(arg1, ...)   -- Call public methods normally
    private_method(self, arg1, ...) -- Use this to call private methods
end
```
