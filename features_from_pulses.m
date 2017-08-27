function X = features_from_pulses(W, fs, env_fs, debug, silent)

if nargin < 4
  debug = 0;
end
if nargin < 5
  silent = 0;
end

pkg load signal;

% ratio between signal-fs and envelope-fs
r = round(fs / env_fs);
% truncate W so that is multiple of r
W_end = floor(size(W, 2) / r) * r;
W = W(:, 1:W_end);
% time-domain features length
nt = size(W, 2) / r;
% frequency-domain features length
nf = nt;
% autocorrelation of frequency-domain features length
nfx = nf;

%
% output variables
%
X = zeros(size(W, 1), nt + nf + nfx);

% calculate fft for every row
WS = abs(fft(W, [], 2));
% ignore what is after nyquist
WS = WS(:, 1:size(WS, 2)/2);
% calculate time-domain envelope
for i = 1:size(W, 1)
  if silent == 0
    fprintf(' features_from_pulses: %d/%d\r', i, size(W, 1));
  endif
  fflush(stdout);
  % get one pulse
  w = W(i, :);
  % ignore negative values
  w(find(w < 0)) = 0;
  % first part of features is time domain envelope (downsampled of a factor r)
  X(i, 1:nt) = fastsmooth(envelope(w, r), 5);
  if (debug)
    figure
    subplot(3,1,1)
    plot(w, 'b', 1:r:length(w), X(i, 1:nt), '-or', 'linewidth', 2)
  end
  % get spectrum of current pulse
  ws = WS(i, :);
  % second part of features is frequency domain envelope (downsampled of a factor r)
  wse = envelope(ws, r/2);
  X(i, nt+1:nt+nf) = wse;
  if (debug)
    subplot(3,1,2)
    plot(ws, 'b', 1:r/2:length(ws), X(i, nt+1:nt+nf), '-om', 'linewidth', 2)
  end
  % third part of features is xcorr of frequency domain envelope
  xwse = xcorr(wse);
  X(i, nt+nf+1:end) = xwse(nfx:end);
  if (debug)
    subplot(3,1,3)
    plot(X(i, nt+nf+1:end), '-oc', 'linewidth', 2)
  end
end
if silent == 0
  fprintf('\n');
endif
