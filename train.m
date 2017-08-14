function [model] = train(algo)

clear ; close all; clc
load 'data.bin'

if nargin < 1
  algo = 'lr';
end

if algo == 'lr'
  addpath('logreg')
end

possible_lambdas = [0 0.01 0.02 0.03 0.04 0.05 ...
                    0.08 0.16 0.32 0.64 1.28 2.56 5.12 10.24];
Jtrain = zeros(1, length(possible_lambdas));
Jtest = zeros(1, length(possible_lambdas));
Models(1:length(possible_lambdas)) = struct('data', []);

fprintf('\n');
for lambda_idx = 1:length(possible_lambdas)
  lambda = possible_lambdas(lambda_idx);
  if algo == 'lr'
    fprintf('training with lambda %d\r', lambda);
    [cost_train, cost_test, algo_params] = log_reg_train(lambda, n, ...
                                                         Xtrain, ytrain, ...
                                                         Xtest, ytest);
  end
  fflush(stdout);
  % store costs
  Jtrain(lambda_idx) = cost_train;
  Jtest(lambda_idx) = cost_test;
  % store theta
  Models(lambda_idx).data = algo_params;
end
fprintf('Training done                                   \r');
fprintf('\n\n');
% find min cost
[min_cost_test, min_cost_test_idx] = min(Jtest);
% predict based on algorithm
if algo == 'lr'
  plot(possible_lambdas, Jtrain, '-or', possible_lambdas, Jtest, '-og')
  fprintf('Best lambda:               %d\n', possible_lambdas(min_cost_test_idx));
  fprintf('Train cost at best lambda: %d\n', Jtrain(min_cost_test_idx));
  fprintf('Test cost at best lambda:  %d\n', Jtest(min_cost_test_idx));
  model = Models(min_cost_test_idx).data;
  [tr_acc, tr_match, tr_tot] = log_reg_get_acc(model, Xtrain, ytrain);
  [te_acc, te_match, te_tot] = log_reg_get_acc(model, Xtest, ytest);
end
fprintf('Train accuracy:            %f (%d/%d)\n', tr_acc, tr_match, tr_tot);
fprintf('Test accuracy:             %f (%d/%d)\n', te_acc, te_match, te_tot);

end
