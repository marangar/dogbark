function [W, x, y] = predict_from_file(fname, theta, is_dog, ...
                                       min_pulse_len, max_pulse_len, fs, efs, dbg)

oldpager = PAGER('less > /dev/null');
oldpso = page_screen_output(1);
oldpoi = page_output_immediately(1);

W = isolate_pulses(fname, min_pulse_len, max_pulse_len, fs, dbg);
x = features_from_pulses(W, fs, efs, 0);
x = [ones(size(x, 1), 1) x];
y = x * theta;

PAGER(oldpager);
page_screen_output(oldpso);
page_output_immediately(oldpoi);

fflush(stdout);
if is_dog
  fprintf('%-50s: errors: %d\n', fname, length(find(y < 0)));
else
  fprintf('%-50s: errors: %d\n', fname, length(find(y >= 0)));
end
fflush(stdout);

end