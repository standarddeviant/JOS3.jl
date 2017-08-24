% Obtained from https://ccrma.stanford.edu/~jos/filters/Frequency_Response_Plots_plotfr_m.html

function [plothandle] = plotfr(X,f);
% PLOTFR - Plot frequency-response magnitude & phase.
%          Requires Mathworks Matlab.
%
% X = frequency response
% f = vector of corresponding frequency values

Xm = abs(X);         % Amplitude response
Xmdb = 20*log10(Xm); % Prefer dB for audio work
Xp = angle(X);       % Phase response

if nargin<2, N=length(X); f=(0:N-1)/(2*(N-1)); end
subplot(2,1,1);
plot(f,Xmdb,'-k'); grid;
ylabel('Gain (dB)');
xlabel('Normalized Frequency (cycles/sample)');
axis tight;
text(-0.07,max(Xmdb),'(a)');

subplot(2,1,2);
plot(f,Xp,'-k'); grid;
ylabel('Phase Shift (radians)');
xlabel('Normalized Frequency (cycles/sample)');
axis tight;
text(-0.07,max(Xp),'(b)');

if exist('OCTAVE_VERSION')
  plothandle = 0; % gcf undefined in Octave
else
  plothandle = gcf;
end