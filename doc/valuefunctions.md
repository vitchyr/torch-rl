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
