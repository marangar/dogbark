clear ; close all; clc

load 'data.bin'

possible_lambdas = [0 0.01 0.02 0.04 0.08 0.16 0.32 0.64 1.28 2.56 5.12 10.24];
Jtrain = zeros(1, length(possible_lambdas));
Jtest = zeros(1, length(possible_lambdas));
Thetas = zeros(n + 1, length(possible_lambdas));

for lambda_idx = 1:length(possible_lambdas)
  lambda = possible_lambdas(lambda_idx);
  fprintf('\n\n training with lambda %d\n', lambda);
  % initialize fitting parameters
  initial_theta = zeros(n + 1, 1);
  % compute initial cost and gradient
  fprintf('computing initial cost\n');
  [cost, grad] = log_reg_cost(initial_theta, Xtrain, ytrain, lambda);
  fprintf('Cost at initial theta (zeros): %f\n', cost);
  % set options for fminunc
  options = optimset('GradObj', 'on', 'MaxIter', 400);
  %  minimize cost function
  [theta, cost] = ...
    fminunc(@(t)(log_reg_cost(t, Xtrain, ytrain, lambda)), initial_theta, options);
  % minimum cost found
  fprintf('Cost at theta found by fminunc: %f\n', cost);
  % cost for train set
  [cost_train, grad_train] = log_reg_cost(theta, Xtrain, ytrain, 0);
  fprintf('Cost for train set: %f\n', cost_train);
  % cost for test set
  [cost_test, grad_test] = log_reg_cost(theta, Xtest, ytest, 0);
  fprintf('Cost for test set: %f\n', cost_test);
  % store costs
  Jtrain(lambda_idx) = cost_train;
  Jtest(lambda_idx) = cost_test;
  % store theta
  Thetas(:, lambda_idx) = theta;
  fflush(stdout);
end
fprintf('\n\n');
plot(possible_lambdas, Jtrain, '-or', possible_lambdas, Jtest, '-og')
% find best lambda
[min_cost_test, min_cost_test_idx] = min(Jtest);
fprintf('Best lambda: %d\n', possible_lambdas(min_cost_test_idx));
fprintf('Train cost at best lambda: %d\n', Jtrain(min_cost_test_idx));
fprintf('Test cost at best lambda: %d\n', Jtest(min_cost_test_idx));
% get theta corresponding to best lambda
theta = Thetas(:, min_cost_test_idx);
% compute train accuracy
p = predict(theta, Xtrain);
fprintf('Train accuracy: %f\n', mean(double(p == ytrain)) * 100);
% compute test accuracy
p = predict(theta, Xtest);
fprintf('Test accuracy: %f\n', mean(double(p == ytest)) * 100);


