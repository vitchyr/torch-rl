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
This type of explorer chooses epsilon to be

`N0 / (N0 + N(s))`

where `N0` is some constant, and `N(s)` is the number of times state `s` has
been visited. This type of exploration strategy with EpsilonGreedyPolicy is
guaranteed to converge to the optimal policy since each state is explored, but
eventually the best action is exploited. This is because as the number of times
states has been visited explored (i.e. the more exploration we've done) the
smaller epsilon because (i.e. don't bother exploring as much).
