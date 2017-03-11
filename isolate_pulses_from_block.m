function [P, check_line] = isolate_pulses_from_block(block, power_block, ...
                                                     power_slot_size, ...
                                                     min_pulse_slots, p_th, ...
                                                     debug)
P = 0;
check_line = zeros(1, length(block));

avg_power = mean(power_block);
over_thresh = power_block > (avg_power * p_th);
[group_count, group_value] = runlength(over_thresh);
group_value(find(group_count < min_pulse_slots)) = 0;
group_ends = cumsum(group_count);
group_starts = [0 group_ends(1 : end - 1)] + 1;
group_limits = [group_starts; group_ends];
oth_limits   = group_limits(:, find(group_value == 1));

for i = 1:size(oth_limits, 2)
  g_start = oth_limits(1, i);
  g_end = oth_limits(2, i);
  if debug
    check_line((g_start - 1) * power_slot_size + 1 : g_end * power_slot_size) = 1;
  end
end