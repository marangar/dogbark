function X = features_from_pulses(W, fs, env_fs, debug)

if nargin < 3
  debug = 0;
end

% ratio between signal-fs and envelope-fs
r = round(fs / env_fs);
% truncate W so that is multiple of r
W_end = floor(size(W, 2) / r) * r;
W = W(:, 1:W_end);
% time-domain features length
nt = size(W, 2) / r;
% frequency-domain features length
nf = nt;

%
% output variables
%
X = zeros(size(W, 1), nt + nf);

% calculate fft for every row
WS = abs(fft(W, [], 2));
% ignore what is after nyquist
WS = WS(:, 1:size(WS, 2)/2);
% calculate time-domain envelope
for i = 1:size(W, 1)
  fprintf(' features_from_pulses: %d/%d\r', i, size(W, 1));
  fflush(stdout);
  % get one pulse
  w = W(i, :);
  % ignore negative values
  w(find(w < 0)) = 0;
  % normalize amplitude
  w = w * 1/max(w);
  % first half of features is time domain envelope (downsampled of a factor r)
  X(i, 1:nt) = envelope(w, r);
  if (debug)
    figure
    subplot(2,1,1) 
    plot(w, 'b', 1:r:length(w), X(i, 1:nt), '-or', 'linewidth', 2)
  end
  % get spectrum of current pulse
  ws = WS(i, :);
  % normalize amplitude
  ws = ws * 1/max(ws);
  % second half of features is frequency domain envelope (downsampled of a factor r)
  X(i, nt+1:end) = envelope(ws, r/2);
  if (debug)
    subplot(2,1,2) 
    plot(ws, 'b', 1:r/2:length(ws), X(i, nt+1:end), '-om', 'linewidth', 2)
  end
end
fprintf('\n');
