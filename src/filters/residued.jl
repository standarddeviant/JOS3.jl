# Adapted from https://ccrma.stanford.edu/~jos/filters/Partial_Fraction_Expansion_residued_m.html

using DSP # requires DSP module for filt, equivalent Julia function to filter

function residued(b, a, toler)
if nargin<3, toler=0.001; end
NUM = vec(b);
DEN = vec(a);
nb = length(NUM);
na = length(DEN);
f = [];
if na<=nb
  f = filt(NUM,DEN,[1,zeros(nb-na)]);
  NUM = NUM - conv(DEN,f);
  NUM = NUM(nb-na+2:end);
end
[r,p,f2,e] = residuez(NUM,DEN,toler);

return [r, p, f, e]