function [Xn, norm_params] = feat_norm_n_scale(X, norm_params)

  m = size(X, 1);
  n = size(X, 2);

  if nargin == 1
    % get mean and std deviation
    u = mean(X, 1);
    s = std(X, 1);
    s(find(s == 0)) = 1e-6;
  else
    u = norm_params.u;
    s = norm_params.s;
  end
  % normalize
  Xn = (X - repmat(u, m, 1)) ./ repmat(s, m, 1);

  if nargin == 1
    % get max value
    h = max(abs(Xn));
    h(find(h == 0)) = 1e-6;
  else
    h = norm_params.h
  end
  % scale to [-1 1]
  Xn = Xn ./ repmat(h, m, 1);
  
  norm_params.u = u;
  norm_params.s = s;
  norm_params.h = h;

end
