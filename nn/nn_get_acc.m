function [acc, matched, tot] = nn_get_acc(nn_params, X, y)

p = nn_predict(nn_params, X);
match = double(p == y);
matched = length(find(match == 1));
tot = length(match);
acc = matched / tot * 100;

end