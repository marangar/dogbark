# dogbark
Experiments with dog bark recognition, after attending coursera machine-learning course from andrew ng

## Usage
Compile libsvm by running:
```
libsvm/matlab/make.m
```
Setup directories containing wav files for dog barks and non-dog-bark sounds inside:
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

## How it works
Classification algorithms are basic/3rd-party implementations of support-vector machine, logistic regression and neural networks.<br>
Most of the effort is about extracting features from data wav files: each wav file is divided in 'pulses' and spectrum of each pulse is calculated with FFT. The envelope of amplitude and phase spectrum is used as the feature set.<br><br>
If training data is clean (i.e. dog wav files contain only dog barks, and not-dog wav files contain only non-dog-bark sounds) accuracy can be high with a relatively small dataset. For example, this dataset has 60 wav files for dog-barks and 38 wav files for non-dog-bark sounds, having less than 300KB average size:
```
ls /data/MLData/wavs_original/dog/*.wav | wc -l
60
ls -l /data/MLData/wavs_original/dog/*.wav | awk '{sum += $5; n++;} END {print sum/n;}'
288805

ls /data/MLData/wavs_original/not_dog/*.wav | wc -l
38
ls -l /data/MLData/wavs_original/not_dog/*.wav | awk '{sum += $5; n++;} END {print sum/n;}'
235392
```
Accuracy after training is 98.82%:
```
>> train_svm

Training done

Best C:                    100
Train cost at best C:      -1255.35
Train accuracy:            100.000000 (853/853)
Test accuracy:             98.826300 (421/426)
Total errors:              5
>>
```
