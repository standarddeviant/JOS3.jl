% Obtained from https://ccrma.stanford.edu/~jos/filters/Partial_Fraction_Expansion_residued_m.html

function [r, p, f, e] = residued(b, a, toler)
if nargin<3, toler=0.001; end
NUM = b(:)';
DEN = a(:)';
nb = length(NUM);
na = length(DEN);
f = [];
if na<=nb
  f = filter(NUM,DEN,[1,zeros(1,nb-na)]);
  NUM = NUM - conv(DEN,f);
  NUM = NUM(nb-na+2:end);
end
[r,p,f2,e] = residuez(NUM,DEN,toler);