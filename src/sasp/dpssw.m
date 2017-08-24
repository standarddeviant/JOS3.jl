% Obtained from https://ccrma.stanford.edu/~jos/sasp/Matlab_listing_dpssw_m.html
function [w,A,V] = dpssw(M,Wc);
  
% DPSSW - Compute Digital Prolate Spheroidal Sequence window of
% 	  length M, having cut-off frequency Wc in (0,pi).

k = (1:M-1);
s = sin(Wc*k)./ k;
c0 = [Wc,s];
A = toeplitz(c0);
[V,evals] = eig(A); % Only need the principal eigenvector
[emax,imax] = max(abs(diag(evals)));
w = V(:,imax);
w = w / max(w);
