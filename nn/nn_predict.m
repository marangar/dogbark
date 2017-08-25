function pred = nn_predict(nn_params, X)

conf = get_nn_config();
input_layer_size = size(X, 2);
hidden_layer_size = conf.hidden_layer_size;
num_labels = conf.num_labels;

% obtain Theta1 and Theta2 from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));
Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));
% predict    
pred = nn_predict2(Theta1, Theta2, X);
% convert labels
pred(find(pred == 2)) = 0;

end