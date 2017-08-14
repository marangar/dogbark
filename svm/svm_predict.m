function p = svm_predict(model, X)

% labels unknown. Set to '2'
y = ones(size(X, 1), 1) * 2;
output = evalc('[pl, ac, pe] = svmpredict(y, X, model);');
p = pl;

end