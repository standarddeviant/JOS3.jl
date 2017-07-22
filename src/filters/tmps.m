% Obtained from https://ccrma.stanford.edu/~jos/filters/Matlab_listing_tmps_m.html
spec = [1 1 1 0 0 0 1 1]'; % Lowpass cutting off at fs*3/8
format short;
mps(spec)
abs(mps(spec))
ifft(spec)
ifft(mps(spec))