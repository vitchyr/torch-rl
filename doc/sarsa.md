## Sarsa-lambda
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

### Sarsa-lambda Analysis Scripts
Below are more intesting scripts that compare Sarsa-lambda algorithms perform
relative to Monte Carlo (MC) Control.
* `analyze_table_sarsa.lua`
* `analyze_lin_sarsa.lua`
* `analyze_nn_sarsa.lua`

MC Control is used as a baseline because it gives an unbiased estimate of the
true Q (state-action value) function. In each of the scripts, two plots get
generated: (1) root mean square (RMS) error of the estimated Q function vs
lambda. (2) RMS error of the estimated Q function vs # iterations for lambda = 0
and lambda = 1.

To save time, you can generated the Q function from MC Control, save
it, and then load it back up in the above scripts. Generate a MC Q file with

`$ th generate_q_mc.lua -saveqto <FILE_NAME>.dat`

and use this file when running the above scripts with the following.

`$ th analyze_table_sarsa.lua -loadqfrom <FILE_NAME>.dat`

Run these scripts with the -h option for more help.
