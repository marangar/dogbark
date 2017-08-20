function [W, X, p] = predict_from_file(fname, algo, algo_params, is_dog, ...
                                       min_pulse_len, max_pulse_len, fs, efs, dbg)

gen_err = 0;

oldpager = PAGER('less > /dev/null');
oldpso = page_screen_output(1);
oldpoi = page_output_immediately(1);

try
  W = isolate_pulses(fname, min_pulse_len, max_pulse_len, fs, dbg);
  X = features_from_pulses(W, fs, efs, 0);
  if strcmp(algo, 'lr')
    X = [ones(size(X, 1), 1) X];
    p = log_reg_predict(algo_params, X);
  elseif strcmp(algo, 'svm')
    p = svm_predict(algo_params, X);
  end
catch
  gen_err = 1;
  W=0;X=0;p=0;
end

PAGER(oldpager);
page_screen_output(oldpso);
page_output_immediately(oldpoi);

if gen_err
  fprintf('generic error!\n');
  fflush(stdout);
  return;
end

fflush(stdout);
if is_dog
  fprintf('%-50s: errors: %d\n', fname, length(find(p == 0)));
else
  fprintf('%-50s: errors: %d\n', fname, length(find(p == 1)));
end
fflush(stdout);

end