clear ; close all; clc

wav_dir_yes = '../wavs_original/dog/';
wav_dir_no = '../wavs_original/not_dog/';
min_pulse_len = 0.1;
max_pulse_len = 0.4;
fs = 8000;
efs = 500;
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
% get features for dog barks
fprintf('Get features for dog barks\n', wavf);
Xyes = features_from_pulses(Wyes, fs, efs, debug);
% get features for non-dog barks
fprintf('Get features for non-dog barks\n', wavf);
Xno = features_from_pulses(Wno, fs, efs, debug);
% compose X and y
X = [Xyes; Xno];
y = [ones(size(Xyes, 1), 1); zeros(size(Xno, 1), 1)];
clear -x X y
[m, n] = size(X);
% shuffle rows of X and y
rand_rows = randperm(m);
X = X(rand_rows, :);
y = y(rand_rows);
% add intercept term to X
X = [ones(m, 1) X];
% split data in train-set and test-set
border = round(2/3*m);
Xtrain = X(1:border, :);
ytrain = y(1:border, :);
Xtest = X(border + 1:end, :);
ytest = y(border + 1:end, :);
mtrain = size(Xtrain, 1);
mtest = size(Xtest, 1);
% clean memory
clear X 
clear y 
clear rand_rows
clear m
% save to file
save 'data.bin'