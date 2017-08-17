function check_pulse_segmentation_by_file(debug)

close all;
conf = get_config();

wav_dir_yes = conf.wav_dir_yes;
wav_dir_no = conf.wav_dir_no;
min_pulse_len = conf.min_pulse_len;
max_pulse_len = conf.max_pulse_len;
fs = conf.fs;
efs = conf.efs;

files = dir(strcat(wav_dir_yes, '*.wav'));
for i = 1:length(files)
  wavf = strcat(wav_dir_yes, files(i).name);
  fprintf("file: %s\n", wavf);
  W = isolate_pulses(wavf, min_pulse_len, max_pulse_len, fs, debug);
  k = waitforbuttonpress;
  close all;
end

end