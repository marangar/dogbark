function check_pulse_segmentation_by_file(debug)

wav_dir_yes = '../wavs_original/dog/';
wav_dir_no = '../wavs_original/not_dog/';
min_pulse_len = 0.1;
max_pulse_len = 0.45;
fs = 8000;
efs = 500;

close all
files = dir(strcat(wav_dir_yes, '*.wav'));
for i = 1:length(files)
  wavf = strcat(wav_dir_yes, files(i).name);
  fprintf("file: %s\n", wavf);
  W = isolate_pulses(wavf, min_pulse_len, max_pulse_len, fs, debug);
  k = waitforbuttonpress;
  close all;
end

end