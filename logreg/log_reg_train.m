function [cost_train, cost_test, theta] = log_reg_train(lambda, ...
                                                        Xtrain, ytrain, ...
                                                        Xtest, ytest)
  % initialize fitting parameters
  initial_theta = zeros(size(Xtrain, 2), 1);
  % compute initial cost and gradient
  [cost, grad] = log_reg_cost(initial_theta, Xtrain, ytrain, lambda);
  % set options for fminunc
  options = optimset('GradObj', 'on', 'MaxIter', 400);
  %  minimize cost function
  [theta, cost] = ...
    fminunc(@(t)(log_reg_cost(t, Xtrain, ytrain, lambda)), initial_theta, options);
  % cost for train set
  [cost_train, grad_train] = log_reg_cost(theta, Xtrain, ytrain, 0);
  % cost for test set
  [cost_test, grad_test] = log_reg_cost(theta, Xtest, ytest, 0);
end