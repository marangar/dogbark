function W = isolate_pulses(wav_file, min_pulse_len, max_pulse_len, ...
                            target_fs, debug)

if nargin < 5
  debug = 0;
end

%
% output variables
%
W = [];

% check and read input wav
try
  [w, fs] = audioread(wav_file);
  w = w';
catch
  fprintf("Error in wav read\n");
  return
end

% wavs could have different sample rate
if fs != target_fs
  pkg load signal;
  w = resample(w, target_fs, fs);
  fs = target_fs;
end

%
% algorithm parameters
%
power_slot_size = 0.01;        % seconds
p_thresh_factor = 0.1;         % threshold is 1/10 of total average power
min_slots = min_pulse_len ... 
            / power_slot_size; % minimum consecutive power-slots above threshold
peak_thresh = 0.5;             % threshold for pulse peak
         
% calculate internal parameters
pt = round(fs * power_slot_size);
block_length = round(max_pulse_len * fs);
% round vector so that it can be divided by pt
w_end = floor(length(w) / pt) * pt;
w = w(1:w_end);
% normalize amplitude
w = w * 1/max(w); 
% divide signal in slots of pt samples each
w_rsh = reshape(w, pt, length(w) / pt);
% calculate power of signal for each slot of pt samples
p = sumsq(w_rsh, 1); 
% find slots where power is above threshold
over_thresh = p > mean(p)*p_thresh_factor;
% group consecutive slots where power is above threshold
[group_count, group_value] = runlength(over_thresh);
% exclude group of slots with less than min_slots elements
group_value(find(group_count < min_slots)) = 0;
% find start and end of each group
group_ends   = cumsum(group_count);
group_starts = [0 group_ends(1 : end - 1)] + 1;
group_limits = [group_starts; group_ends];
oth_limits   = group_limits(:, find(group_value == 1));
% split original signal in blocks having power above threshold
if debug
  check_line = zeros(1, length(w));
  power_line = zeros(1, length(w));
end
% oth_limits should have few elements; no need for vectorized code
for i = 1:size(oth_limits, 2)
  group_start = oth_limits(1, i);
  group_end = oth_limits(2, i);
  b_start = (group_start - 1) * pt + 1;
  b_end   = group_end * pt;
  block   = w(b_start:b_end);
  % drop blocks that are too weak (signal is already normalized)
  if max(block) < peak_thresh
    continue
  end
  power_block = p(group_start:group_end);
  [P, p_line] = isolate_pulses_from_block(block, power_block, pt, ...
                                          max_pulse_len / power_slot_size, ...
                                          min_slots, debug);
  if debug
    fprintf("isolated block [%d : %d] (len = %d samples)\n", b_start, b_end, length(block));
    check_line(b_start:b_end) = 1;
    power_line(b_start:b_end) = p_line;
  end
  W = [W; P];
end
if debug
  % check result visually
  t = 0:1/fs:(length(w)-1)/fs;
  plot(t, w, 'b', t, check_line, 'r', 'linewidth', 2, t, power_line, 'c', 'linewidth', 2)
end

