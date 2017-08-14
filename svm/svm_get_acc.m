function [acc, matched, tot] = svm_get_acc(model, X, y)

output = evalc('[pl, ac, pe] = svmpredict(y, X, model);');
r = regexp(output, 'Accuracy = ([0-9]+\.*[0-9]*)% \(([0-9]+)/([0-9]+)\)', 'tokens');
acc = str2double(r{1}{1});
matched = str2double(r{1}{2});
tot = str2double(r{1}{3});

end