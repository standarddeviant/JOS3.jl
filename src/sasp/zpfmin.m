% Obtained from https://ccrma.stanford.edu/~jos/sasp/Matlab_listing_zpfmin_m.html

function [zpmin] = zpfmin(window,MT,freqBiasMax);
% [zpmin] = zpfmin(window,MT,freqBiasMax)
% returns the minimum zero-padding factor to achieve prescribed
% tolerances in sinusoidal peak parameters measured using the QIFFT
% method with the  window.
%
% INPUTS:
%   window      = 'rect', 'hamming', 'hann', or 'blackman'
%   MT          = window length (seconds)
%   freqBiasMax = max frequency bias allowed in peak frequency (Hz)
%   ampBiasMax  = max peak-magnitude bias allowed (relative fraction)
%
%   If ampBiasMaxPct is not specified, amplitude bias is not considered.
%
% RETURNED:
%   zpmin = minimum zero-padding factor (1 means no zero padding)
% 
% EXAMPLE
%   Assuming the window contains one cycle of a sinusoid whose
%   frequency f must be estimated to within 0.1% accuracy, we have
%   zpfmin('blackman',1/f,0.001*f) = 1.9 for min zero-padding factor.
%   Similarly,
%     2 cycles under the Blackman window yields zpf > 1.5
%     4 cycles under the Blackman window yields zpf > 1.2
%     6 cycles under the Blackman window yields zpf > 1.02
%
% Reference:
%    "Design Criteria for Simple Sinusoidal Parameter Estimation 
%     based on Quadratic Interpolation of FFT Magnitude Peaks", by
%    Mototsugu Abe and Julius O. Smith, 
%    Audio Engineering Society Convention preprint 6256", NY, 2004.

%!test
%! assert(zpfmin('blackman',1,0.001),2.3609,0.001);

% disp(sprintf('%s window',window));
switch window
 case 'rect'
  c0 = 0.4467;
  r0 = -0.3218;
  c1 = 0.8560;
  r1 = -0.2366;
 case 'hamming'
  c0 = 0.2456;
  r0 = -0.3282;
  c1 = 0.4381;
  r1 = -0.2451;
 case 'hann'
  c0 = 0.2436;
  r0 = -0.3288;
  c1 = 0.4149;
  r1 = -0.2456;
 case 'blackman'
  c0 = 0.1868;
  r0 = -0.3307;
  c1 = 0.3156;
  r1 = -0.2475;
 otherwise
  error(sprintf('Window type %s unknown - say help zpfmin',window));
end

zpmin = c0*(MT*freqBiasMax)^r0;

if nargin>3
  zpminamp = c1*(MT*freqBiasMax)^r1;
  zpmin = max(zpmin,zpminamp);
end

if strcmp(window,'rect')
  zpmin=max(1.7,zpmin); % See Abe & Smith 2004, Fig. 2 re. why this
else
  zpmin=max(1,zpmin);
end
