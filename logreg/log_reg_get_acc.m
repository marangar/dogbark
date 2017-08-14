function [acc, matched, tot] = log_reg_get_acc(theta, X, y)

p = log_reg_predict(theta, X);
match = double(p == y);
matched = length(find(match == 1));
tot = length(match);
acc = matched / tot * 100;

end