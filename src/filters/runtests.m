% run tests for filters book
if ~exist('jl','class')
    errmsg = 'Please install and addpath to mexjulia to run these tests.';
    errurl = 'https://github.com/twadleigh/mexjulia';
    error('<a href="%s">%s</a>\n',errurl,errmsg);
end


% set tolerance for error checking
tol=1e-9;
% single place to define test vars to clear
cleartestvars = strcat( 'clear(',                                        ...
'''mfh'',''N'',''s'',''cutoff'',''b'',''a'',''nfft'',''whole'',''Fs''',  ...
');');


% clipdb
fstr='clipdb'; jl.include([fstr,'.jl']); mfh=str2func(fstr);
N=1024; s=randn(N,1); cutoff=-15; 
mout=mfh(s,cutoff); jlout=jl.call(fstr,s,cutoff);
compare_mout_jlout(mout,jlout,tol,fstr,cleartestvars);


% fold
fstr='fold'; jl.include([fstr,'.jl']); mfh=str2func(fstr);
N=1024; s=randn(N,1)+1j*randn(N,1); 
mout=mfh(s); jlout=jl.call(fstr,s);
compare_mout_jlout(mout,jlout,tol,fstr,cleartestvars);


% mps
fstr='mps'; jl.include([fstr,'.jl']); mfh=str2func(fstr);
N=1024; s=randn(N,1)+1j*randn(N,1); 
mout=mfh(s); jlout=jl.call(fstr,s);
compare_mout_jlout(mout,jlout,tol,fstr,cleartestvars);


% grpdelay
fstr='grpdelay'; jl.include([fstr,'.jl']); mfh=str2func(fstr);
N=1024; b=randn(N,1); a=1; nfft=1024; whole='whole'; Fs=48000;
[mgd,mw]=mfh(b,a,nfft,whole,Fs); [jlgd,jlw]=jl.mexn(2,fstr,b,a,nfft,whole,Fs);
compare_mout_jlout(mgd,jlgd,tol,[fstr,'-1-gd'],cleartestvars);
compare_mout_jlout(mw ,jlw ,tol,[fstr,'-1-w'],cleartestvars);

N=1024; b=randn(N,1);
[mgd,mw]=mfh(b); [jlgd,jlw]=jl.mexn(2,fstr,b);
compare_mout_jlout(mgd,jlgd,tol,[fstr,'-2-gd'],cleartestvars);
compare_mout_jlout(mw ,jlw ,tol,[fstr,'-2-w'],cleartestvars);



