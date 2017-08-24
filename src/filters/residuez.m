% Obtained from https://ccrma.stanford.edu/~jos/filters/Partial_Fraction_Expansion_residuez_m.html

function [r, p, f, m] = residuez(B, A, tol)
if nargin<3, tol=0.001; end
NUM = B(:)'; DEN = A(:)';
% Matlab's residue does not return m (implied by p):

[r,p,f,m]=residue(conj(fliplr(NUM)),conj(fliplr(DEN)),tol);
p = 1 ./ p;
r = r .* ((-p) .^m);
if f, f = conj(fliplr(f)); end