function p = log_reg_predict(theta, X)

m = size(X, 1);
p = zeros(m, 1);
y = X * theta;
p(find(y >= 0)) = 1;

end