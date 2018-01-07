function conf = get_config()

  conf = [];
  conf.wav_dir_yes = '/data/MLData/wavs_original/dog/';
  conf.wav_dir_no = '/data/MLData/wavs_original/not_dog/';
  %conf.wav_dir_yes = '/data/MLData/wavs_original/urbsnd/dog_foreg/';
  %conf.wav_dir_no = '/data/MLData/wavs_original/urbsnd/not_dog_first1000/';
  conf.min_pulse_len = 0.1;
  conf.max_pulse_len = 0.45;
  conf.fs = 8000;
  conf.efs = 500;

 end