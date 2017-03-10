function env = envelope(signal, down_rate)

%
% output variables
%
env = zeros(1, length(signal) / down_rate);

% find peaks (each at minimum distance down_rate)
%[peak_val, peak_pos] = findpeaks(signal, "MinPeakHeight", 0.1, ...
%                                 "MinPeakDistance", down_rate);
[peak_pos, peak_val] = peakseek(signal, down_rate, 0.01);
% prepare vector that will contain envelope
e = zeros(1, length(signal));
% assign found peaks to envelope
e(peak_pos) = peak_val;
% rest of values of will be interpolated
interp_pos = find(e == 0);
% set boundaries for interpolation
if e(1) == 0
  peak_pos = [1 peak_pos];
  peak_val = [0 peak_val];
end
if peak_pos(end) < (length(e) - down_rate)
  peak_pos = [peak_pos (peak_pos(end) + down_rate)];
  peak_val = [peak_val 0];
end
if peak_pos(end) != length(e)
  peak_pos = [peak_pos length(e)];
  peak_val = [peak_val 0];
end
% interpolate between peaks
interp_val = interp1(peak_pos, peak_val, interp_pos);
e(interp_pos) = interp_val;
% downsample
env = e(1:down_rate:end);