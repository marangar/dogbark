function check_errors_by_file(algo, algo_params, norm_params)

conf = get_config();

wav_dir_yes = conf.wav_dir_yes;
wav_dir_no = conf.wav_dir_no;
debug = 0;

fprintf('Errors for dog barks:\n\n');
fflush(stdout);
files = dir(strcat(wav_dir_yes, '*.wav'));
for i = 1:length(files)
  wavf = strcat(wav_dir_yes, files(i).name);
  predict_from_file(wavf, algo, algo_params, norm_params, 1, debug);
end
fprintf('\n\n');
fprintf('Errors for non-dog barks:\n\n');
fflush(stdout);
files = dir(strcat(wav_dir_no, '*.wav'));
for i = 1:length(files)
  wavf = strcat(wav_dir_no, files(i).name);
  predict_from_file(wavf, algo, algo_params, norm_params, 0, debug);
end
fprintf('\n');
fflush(stdout);

end

