% run tests for filters book
if ~exist('jl','class')
    errmsg = 'Please install and addpath to mexjulia to run these tests.';
    errurl = 'https://github.com/twadleigh/mexjulia';
    error('<a href="%s">%s</a>\n',errurl,errmsg);
end


% set tolerance for error checking
tol=1e-9;
% single place to define test vars to clear
cleartestvars = 'clear(''mfh'',''N'',''s'',''cutoff'');';


% clipdb
fstr='clipdb'; jl.include([fstr,'.jl']); mfh=str2func(fstr);
N=1024; s=randn(N,1); cutoff=-15;
mout=mfh(s,cutoff); jlout=jl.call(fstr,s,cutoff);
if any( abs( mout - jlout ) > tol )
    error('FAILED: %s failed tolerance test\n', fstr);
else
    fprintf('PASSED: %s\n',fstr);
end
eval(cleartestvars);


% fold
fstr='fold'; jl.include([fstr,'.jl']); mfh=str2func(fstr);
N=1024; s=randn(N,1)+1j*randn(N,1);
mout=mfh(s); jlout=jl.call(fstr,s);
if any( abs( mout - jlout ) > tol )
    error('FAILED: %s failed tolerance test\n', fstr);
else
    fprintf('PASSED: %s\n',fstr);
end
eval(cleartestvars);


% mps
fstr='mps'; jl.include([fstr,'.jl']); mfh=str2func(fstr);
N=1024; s=randn(N,1)+1j*randn(N,1);
mout=mfh(s); jlout=jl.call(fstr,s);
if any( abs( mout - jlout ) > tol )
    error('FAILED: %s failed tolerance test\n', fstr);
else
    fprintf('PASSED: %s\n',fstr);
end
eval(cleartestvars);



