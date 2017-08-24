% Obtained from https://ccrma.stanford.edu/~jos/sasp/Non_Parametric_Frequency_Warping.html

function [si] = specinterp(spec,indices);
%SPECINTERP     
%          [si] = specinterp(spec,indices);
%
%          Returns spectrum sampled at indices (from 1).
%          Assumes a causal rectangular window was used.
%          The spec array should be the WHOLE spectrum,
%          not just 0 to half the sampling rate.
%          An "index" is a "bin number" + 1.
% EXAMPLE:
%          N = 128;
%          x = sin(2*pi*0.1*[0:N-1]);
%          X = fft(x);
%          Xi = specinterp(X,[1:0.5:N]); % upsample by 2
%          xi = ifft(x); % should now see 2x zero-padding

N = length(spec);
ibins = indices - 1;
wki = ibins*2*pi/N;

M = length(indices);
si = zeros(1,M);
wk = [0:N-1]*2*pi/N;
for i=1:M
  index = indices(i);
  ri = round(index);
  if abs(index - ri) < 2*eps
    si(i) = spec(ri);
  else
    w = wki(i);
    % ideal interp kernel:
    wts = (1-exp(j*(wk-w)*N)) ./ (N*(1-exp(j*(wk-w))));
    si(i) = sum(wts .* spec);
  end
end