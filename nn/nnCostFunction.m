function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

%
% PART 1
%

X = [ones(m, 1) X];

% from layer 1 to layer 2
A1 = X';
Z2 = Theta1 * A1;
A2 = sigmoid(Z2);
A2 = [ones(1, m); A2];
% from layer 2 to layer 3
Z3 = Theta2 * A2;
A3 = sigmoid(Z3); % A3 is num_labels-by-m
H = A3;           % H  is num_labels-by-m
% recode y
  % looks like below code is slow...
  %
  % Y = zeros(m, num_labels);
  % for i = 1:m
  %   Y(i, y(i)) = 1;
  % end
Y = [1:num_labels] == y;
% calculate cost
for i = 1:m
  cost = 1/m * (-Y(i, :) * log(H(:, i)) - (1 - Y(i, :)) * log(1 - H(:, i)));
  J = J + cost;
end

% exclude bias terms
_Theta1 = Theta1;
_Theta1(:, 1) = [];
_Theta2 = Theta2;
_Theta2(:, 1) = [];
% calculate regularization term
reg = lambda / (2 * m) * (sum(sumsq(_Theta1)) + sum(sumsq(_Theta2)));
% add to total cost
J = J + reg; 

%
% PART 2 (TODO: vectorize)
%

Delta1 = zeros(size(Theta1));
Delta2 = zeros(size(Theta2));
for i = 1:m
  % get from previously calculated values
  a1 = A1(:, i);
  a2 = A2(:, i); 
  z2 = Z2(:, i);
  a3 = A3(:, i); 
  yy = Y(i, :)'; 
  % calculate deltas
  d3 = a3 - yy;
  d2 = (_Theta2' * d3) .* sigmoidGradient(z2);
  Delta1 = Delta1 + d2 * a1';
  Delta2 = Delta2 + d3 * a2';
end
Theta1_grad = 1/m * Delta1;
Theta2_grad = 1/m * Delta2;

%
% PART 3
%

Reg1 = lambda/m * Theta1;
Reg1(:, 1) = zeros(size(Reg1)(1), 1); % zero first column (bias term)
Reg2 = lambda/m * Theta2;
Reg2(:, 1) = zeros(size(Reg2)(1), 1); % zero first column (bias term)

Theta1_grad = Theta1_grad + Reg1;
Theta2_grad = Theta2_grad + Reg2;


% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
