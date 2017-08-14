function [cost_train, cost_test, model] = svm_train(C, ...
                                                    Xtrain, ytrain, ...
                                                    Xtest, ytest) 
opt = sprintf('-c %d', C);

output = evalc('model = svmtrain(ytrain, Xtrain, opt);');
r = regexp(output, 'obj = (\-*[0-9]+\.[0-9]+),', 'tokens');
cost_train = str2double(r{1}{1});

% can't access svm cost function...
% use (100 - accuracy) of test set as cost_test
output = evalc('[pl, ac, pe] = svmpredict(ytest, Xtest, model);');
cost_test = 100 - ac(1);

end