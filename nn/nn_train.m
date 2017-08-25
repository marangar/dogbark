function [cost_train, cost_test, nn_params] = nn_train(lambda, ...
                                                       Xtrain, ytrain, ...
                                                       Xtest, ytest)

conf = get_nn_config();
input_layer_size = size(Xtrain, 2);
hidden_layer_size = conf.hidden_layer_size;
num_labels = conf.num_labels;
% convert label
ytrain(find(ytrain == 0)) = num_labels;
ytest(find(ytest == 0)) = num_labels;
% initialize fitting parameters
initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);
% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];
% set options fro minimization function
options = optimset('MaxIter', 50);
% Create "short hand" for the cost function to be minimized
costFunction_train = @(p) nnCostFunction(p, input_layer_size, ...
                                         hidden_layer_size, ...
                                         num_labels, Xtrain, ytrain, lambda);
%  minimize cost function
[nn_params, cost] = fmincg(costFunction_train, initial_nn_params, options);
% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));
Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));
% cost for train set
[cost_train, grad_train] = nnCostFunction(nn_params,
                                          input_layer_size, ...
                                          hidden_layer_size, ...
                                          num_labels, Xtrain, ytrain, 0);
% cost for test set
[cost_test, grad_test] = nnCostFunction(nn_params,
                                        input_layer_size, ...
                                        hidden_layer_size, ...
                                        num_labels, Xtest, ytest, 0);

end