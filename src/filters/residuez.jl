# Adapted from https://ccrma.stanford.edu/~jos/filters/Partial_Fraction_Expansion_residuez_m.html

function [r, p, f, m] = residuez(B, A, tol=0.001)
NUM = vec(B); DEN = vec(A);
# Matlab's residue does not return m (implied by p):

[r,p,f,m]=residue(conj(flipdim(NUM,1)),conj(flipdim(DEN,1)),tol);
p = 1 ./ p;
r = r .* ((-p) .^m);
if f, f = conj(flipdim(f,1)); end