function [J, grad] = log_reg_cost(theta, X, y, lambda)

m = length(y);
J = 0;
grad = zeros(size(theta));


h = sigmoid(X * theta);
_theta = theta(2:end); % exclude theta0
J = 1/m * (-y' * log(h) - (1 - y)' * log(1 - h)) + lambda/(2*m) * (_theta' * _theta);
grad_reg = lambda/m * theta;
grad_reg(1) = 0; % exclude theta0
grad = 1/m * ((h - y)' * X)' + grad_reg; 


