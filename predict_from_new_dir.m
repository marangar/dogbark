function predict_from_new_dir(wdir, algo, algo_params, norm_params)

wdir = strcat(wdir, '/');
files = dir(strcat(wdir, '*.wav'));
for i = 1:length(files)
  wavf = strcat(wdir, files(i).name);
  [~, ~, p] = predict_from_new_file(wavf, algo, algo_params, norm_params);
  if length(p) == 0
    continue
  endif
  pos = length(find(p == 1));
  tot = length(p);
  fprintf('%-65s: barks: %02d/%02d   (%02d %%)\n', wavf, pos, tot, ...
                                                   round(pos/tot*100));
end

end