function W = isolate_pulses(wav_file, min_pulse_len, max_pulse_len, ...
                            target_fs, debug)

if nargin < 4
  debug = 0;
end

%
% output variables
%
W = [];

% check and read input wav
try
  [w, fs, nbits] = wavread(wav_file);
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
p_thresh_factor_pulse = 0.25;  % power threshold for detecting single pulses
          
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
  min_slots
  [P, p_line] = get_pulses(block, power_block, pt, min_slots, p_thresh_factor_pulse);
  if debug
    fprintf("isolated block [%d : %d] (len = %d samples)\n", b_start, b_end, length(block));
    check_line(b_start:b_end) = 1;
    power_line(b_start:b_end) = p_line;
  end
  if length(block) > block_length
    % split in mutiple blocks
    num_full_blocks = idivide(length(block), block_length);
    remnant = mod(length(block), block_length) != 0;
    for j = 1:num_full_blocks
      full_block = block(((j - 1) * block_length + 1) : j * block_length);
      W = [W ; full_block];
    end
    if remnant
      partial_block = block(num_full_blocks * block_length + 1 : end);
      % drop partial_block shorter than min_pulse_len
      if length(partial_block) > min_pulse_len * fs
        partial_block = [partial_block repmat(0, 1, block_length - length(partial_block))];
        W = [W ; partial_block];
      else
        remnant = 0;
      end
    end
    if debug
      fprintf("   split block in (%d+%d) parts\n", num_full_blocks, remnant);
    end
  elseif length(block) < block_length
    % pad with zeros at the end
    block = [block repmat(0, 1, block_length - length(block))];
    W = [W ; block];
  else
    W = [W ; block];
  end
end
if debug
  % check result visually
  t = 0:1/fs:(length(w)-1)/fs;
  plot(t, w, 'b', t, check_line, 'r', 'linewidth', 2, t, power_line, 'c', 'linewidth', 2)
end


function [P, check_line] = get_pulses(block, power_block, power_slot_size, min_slots, pth)
P = 0;
check_line = zeros(1, length(block));

avg_power = mean(power_block);
over_thresh = power_block > (avg_power * pth);
[group_count, group_value] = runlength(over_thresh);
group_value(find(group_count < min_slots)) = 0;
group_ends = cumsum(group_count);
group_starts = [0 group_ends(1 : end - 1)] + 1;
group_limits = [group_starts; group_ends];
oth_limits   = group_limits(:, find(group_value == 1));

for i = 1:size(oth_limits, 2)
  g_start = oth_limits(1, i);
  g_end = oth_limits(2, i);
  check_line((g_start - 1) * power_slot_size + 1 : g_end * power_slot_size) = 1;
end
