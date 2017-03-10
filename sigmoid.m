function g = sigmoid(z)

g = zeros(size(z));

g = 1 ./ (1 + exp(-z));

g(g == 1) = 0.9999999999999999;

