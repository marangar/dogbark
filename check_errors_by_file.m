function check_errors_by_file(theta)

wav_dir_yes = '../wavs_original/dog/';
wav_dir_no = '../wavs_original/not_dog/';
min_pulse_len = 0.1;
max_pulse_len = 0.45;
fs = 8000;
efs = 500;

fprintf('Errors for dog barks:\n\n');
fflush(stdout);
files = dir(strcat(wav_dir_yes, '*.wav'));
for i = 1:length(files)
  wavf = strcat(wav_dir_yes, files(i).name);
  predict_from_file(wavf, theta, 1, ...
                    min_pulse_len, max_pulse_len, fs, efs, 0);
end
fprintf('\n\n');
fprintf('Errors for non-dog barks:\n\n');
fflush(stdout);
files = dir(strcat(wav_dir_no, '*.wav'));
for i = 1:length(files)
  wavf = strcat(wav_dir_no, files(i).name);
  predict_from_file(wavf, theta, 0, ...
                    min_pulse_len, max_pulse_len, fs, efs, 0);
end
fprintf('\n');
fflush(stdout);

end

