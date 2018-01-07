clear ; close all; clc

conf = get_config();

wav_dir_yes = conf.wav_dir_yes;
wav_dir_no = conf.wav_dir_no;
min_pulse_len = conf.min_pulse_len;
max_pulse_len = conf.max_pulse_len;
fs = conf.fs;
efs = conf.efs;
debug = 0;

% collect pulses for dog-barks
Wyes = [];
files = dir(strcat(wav_dir_yes, '*.wav'));
for i = 1:length(files)
  fprintf('Isolate pulses for dog barks. %d/%d\r', i, length(files));
  fflush(stdout);
  wavf = strcat(wav_dir_yes, files(i).name);
  if debug
    fprintf('\n\nProcessing %s\n', wavf);
    figure;
  end
  Wyes = [Wyes; isolate_pulses(wavf, min_pulse_len, max_pulse_len, ...
                               fs, debug)];
end
fprintf('\n');
if debug
  k = waitforbuttonpress;
end
% collect pulses for non-dog-barks
Wno = [];
files = dir(strcat(wav_dir_no, '*.wav'));
for i = 1:length(files)
  fprintf('Isolate pulses for non-dog barks. %d/%d\r', i, length(files));
  fflush(stdout);
  wavf = strcat(wav_dir_no, files(i).name);
  if debug
    fprintf('\n\nProcessing %s\n', wavf);
    figure;
  end
  Wno = [Wno; isolate_pulses(wavf, min_pulse_len, max_pulse_len, ...
                             fs, debug)];
end
fprintf('\n');
if debug
  k = waitforbuttonpress;
end
% get features for dog barks
fprintf('Get features for dog barks\n');
Xyes = features_from_pulses(Wyes, fs, efs, debug);
% get features for non-dog barks
fprintf('Get features for non-dog barks\n');
Xno = features_from_pulses(Wno, fs, efs, debug);
% compose X and y
X = [Xyes; Xno];
y = [ones(size(Xyes, 1), 1); zeros(size(Xno, 1), 1)];
% normalize and scale
[X, norm_params] = feat_norm_n_scale(X);
clear -x X y norm_params
[m, n] = size(X);
% add intercept term to X
X = [ones(m, 1) X];
% split data in train-set (2/3) and test-set (1/3)
Xtrain = X(1:3:end, :);
Xtrain = [Xtrain ; X(2:3:end, :)];
ytrain = y(1:3:end, :);
ytrain = [ytrain ; y(2:3:end, :)];
Xtest = X(3:3:end, :);
ytest = y(3:3:end, :);
% get set sizes
mtrain = size(Xtrain, 1);
mtest = size(Xtest, 1);
% shuffle train set
rand_rows = randperm(mtrain);
Xtrain = Xtrain(rand_rows, :);
ytrain = ytrain(rand_rows);
% shuffle test set
rand_rows = randperm(mtest);
Xtest = Xtest(rand_rows, :);
ytest = ytest(rand_rows);
% clean memory
clear X 
clear y 
clear rand_rows
clear m
% save to file
save 'data.bin'