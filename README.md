# torch-rl
This is a Torch 7 package the implements a few reinforcement learning
algorithms. So far, we've only implemented Q-learning.

## Common Classes
### MDP
Markov Decision Proccesses (MDPs) are at the heard of the RL algorithms
implemented. Here, they are represented as a class.  The definition of the MDP
class will depend on the particular problem.

The MDP must implement two methods:
    `[next_state, reward] step(s, a)` - given a state and action, returns the
    next state and reward for taking that action.

    `[boolean] is_terminal(s)` - returns if a state is terminal

### Agent
The Agent is responsible for 'playing' out an episode of the MDP. It must be
given an MDP and implements two methods:

    `[number] sample_reward(policy)`
        Samples the reward of a given policy.

    `[episode] get_episode(policy)`
        Return an episode by following the trajectory of a given policy.

### Policy
A Policy implements one method:

    `[action] get_action(state)`

#### Greedy Policy
For greedy policies, with probablity epsilon, choose a random action. Otherwise,
choose the best action.

#### Exploration Strategy
This is used to choose how to balance exploration vs. exploitation.


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

### Function Approximators

## Algorithms
These algorithms are used to improve policies and/or Q functions.
### Monte Carlo Control
Monte Carlo (MC) estimates the value of a state-action pair under a given
policy by sampling and taking the average. MC Control alternates between this
Q-function estimation and epsilon-greedy policy improvement.

Example use:

```
mc = MonteCarloControl(env)
policy = mc.improve_policy_for_n_iters(n_iters)

learned_action = policy.get_action(state)
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
