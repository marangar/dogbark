function [W, X, p] = predict_from_new_file(fname, algo, algo_params, ...
                                           norm_params)

conf = get_config();
min_pulse_len = conf.min_pulse_len;
max_pulse_len = conf.max_pulse_len;
fs = conf.fs;
efs = conf.efs;

W = isolate_pulses(fname, min_pulse_len, max_pulse_len, fs, 0);
if length(W) == 0
  fprintf('No pulses found\n');
  W = []; X = []; p = [];
  return
endif
X = features_from_pulses(W, fs, efs, 0, 1);
X = feat_norm_n_scale(X, norm_params);
if strcmp(algo, 'lr')
  X = [ones(size(X, 1), 1) X];
  p = log_reg_predict(algo_params, X);
elseif strcmp(algo, 'svm')
  p = svm_predict(algo_params, X);
elseif strcmp(algo, 'nn')
  p = nn_predict(algo_params, X);
end

end