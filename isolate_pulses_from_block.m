function [P, check_line] = isolate_pulses_from_block(block, power_block, ...
                                                     power_slot_size, ...
                                                     max_pulse_slots, ...
                                                     min_pulse_slots, p_th, ...
                                                     debug)
P = 0;
check_line = zeros(1, length(block));

avg_power = mean(power_block);
% find limits of over-threshold groups
over_thresh = power_block > (avg_power * p_th);
[group_count, group_value] = runlength(over_thresh);
group_value(find(group_count < min_pulse_slots)) = 0;
[group_value, group_count] = merge_zeros(group_value, group_count);
group_ends = cumsum(group_count);
group_starts = [0 group_ends(1 : end - 1)] + 1;
group_limits = [group_starts; group_ends];
oth_limits   = group_limits(:, find(group_value == 1));
bth_limits   = group_limits(:, find(group_value == 0));

if debug
  for i = 1:size(oth_limits, 2)
    p_start = oth_limits(1, i);
    p_end = oth_limits(2, i);
    check_line((p_start - 1) * power_slot_size + 1 : p_end * power_slot_size) = 0.95;
  end
end

p_num = size(oth_limits, 2);
if p_num == 0
  % no emerging pulses
  p_len = length(block);
  if p_len > (max_pulse_slots * power_slot_size)
    l = [1 : round(p_len / 2) ];
    r = [round(p_len / 2) + 1 : p_len ];
    reduce_pulse(block, l, r);
  end
elseif p_num == 1
  % one emerging pulse
  p_len = length(block)
  if p_len > (max_pulse_slots * power_slot_size)
    if group_value(1) == 1
      l = 0;
    else
      l = [1 : bth_limits(2, 1) * power_slot_size];
    end
    if group_value(end) == 1
      r = 0;
    else
      r = [(bth_limits(1, end) - 1) * power_slot_size + 1 : p_len ];  
    end
    reduce_pulse(block, l, r);
  end
end


function red_p = reduce_pulse(pulse, left_margin, rigth_margin)

red_p = pulse;


function [ngv, ngc] = merge_zeros(gv, gc)

ngv = gv;
ngc = gc;
d = [gv(1) diff(gv)];
starts = [1 find(d == -1)];
ends   = find(d == 1);
if ends(end) != length(gv)
  ends = [ends (length(gv) + 1)];
end
for i = length(starts):-1:1
	s = starts(i);
	e = ends(i);
	ngv(s+1:e-1) = [];
	ngc(s) = ngc(s) + sum(ngc(s+1:e-1));
  ngc(s+1:e-1) = [];
end
