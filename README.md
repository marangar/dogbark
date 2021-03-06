# dogbark
Experiments with dog bark recognition, after attending coursera machine-learning course from andrew ng

## usage
Compile libsvm by running:
```
libsvm/matlab/make.m
```
Setup directories containing wav files for dog barks and non-dog barks inside:
```
get_config.m
```
Generate data.bin containing feature variables:
```
get_data
```
Train using one of support-vector-machine, logistic-regression, neural-network:
```
train_svm
train_lr
train_nn
```
Variables `mod` and `norm_params` are now in memory.
Inspect errors of current model for each data file:
```
check_errors_by_file('svm', mod, norm_params)
```
Detect how many dog barks are present in a new wav file:
```
[W, X, p] = predict_from_new_file('my_file.wav', 'svm', mod, norm_params);
sum(p==1)
```
