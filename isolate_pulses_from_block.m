function [pulses, check_line] = isolate_pulses_from_block(block, ...
                                                          power_block, ...
                                                          power_slot_size, ...
                                                          max_pulse_slots, ...
                                                          min_pulse_slots, ...
                                                          debug)
% return values
pulses = [];
check_line = ones(1, length(block)) * 0.95;
% internal variables
window_size = min_pulse_slots;

% compute energy along a sliding window
blk_sum = cumsum(power_block);
blk_nrg = [blk_sum repmat(blk_sum(end), 1, window_size/2)];
blk_nrg_off = [repmat(0, 1, window_size) blk_sum(1 : end - window_size/2)];
win_nrg = blk_nrg - blk_nrg_off;
% smooth energy vector (moving average between adiacent samples)
win_nrg = fastsmooth(win_nrg, 5);
% window-centers where energy is at minimum are considered pulse edges
[pos, val] = peakseek(-win_nrg, window_size);
valley_pos = pos - window_size/2;
if debug == 2
  stem(power_block)
  hold on
  stem([-(window_size/2 - 1):0 1:length(win_nrg)], ...
       [-win_nrg/max(win_nrg)*10 repmat(0, 1, window_size/2)],'r')
  stem(valley_pos, valley_pos*0, 'g', 'MarkerFaceColor', 'g', 'MarkerSize', 10)
  k = waitforbuttonpress;
  hold off
end
% filter out negative positions
valley_pos = valley_pos(find(valley_pos >= 0));
% calculate pulse sizes
pulse_sizes = diff([0 valley_pos*power_slot_size length(block)]);
% separate pulses
pulse_cells = mat2cell(block, 1, pulse_sizes);
if debug == 1
  check_line([1 valley_pos*power_slot_size length(block)]) = 0;
end
for pc = 1 : length(pulse_cells)
  pulse = cell2mat(pulse_cells(1, pc));
  % drop pulses that are below minimum length
  if length(pulse) < min_pulse_slots * power_slot_size
    if debug
      check_line(ismember(block, pulse)) = 0;
    end
    continue
  end
  % add pulse to list
  pulses = [pulses ; normalize_pulse(pulse, max_pulse_slots * power_slot_size)];
end

end

function norm_pulse = normalize_pulse(pulse, norm_size)
  if length(pulse) == norm_size
    norm_pulse = pulse;
  elseif length(pulse) < norm_size
    norm_pulse = [pulse zeros(1, norm_size - length(pulse))];
  elseif length(pulse) > norm_size
    norm_pulse = pulse(1 : norm_size);
  end
end
