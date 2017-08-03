% run tests for filters book
if ~exist('jlMatCall','file')
    try
        [jlmatpath,~,~] = fileparts(mfilename('fullpath'));
        jlmatpath = fullfile(jlmatpath, '..','testutils');
        addpath(jlmatpath);
    catch
        error('Failed to load path to jlMatCall (testutils) function');
    end    
end

[thispath,~,~] = fileparts(mfilename('fullpath'));

% set tolerance for error checking
tol=1e-9;
% single place to define test vars to clear
cleartestvars = strcat( 'clear(',                                        ...
'''mfh'',''N'',''s'',''cutoff'',''b'',''a'',''nfft'',''whole'',''Fs''',  ...
'''mgd'',''mw'',''jlgd'',''jlw''',                                       ...
');');

% clipdb
fstr='clipdb'; jlfile=fullfile(thispath,'filters.jl'); mfh=str2func(fstr);
N=16; s=randn(N,1); cutoff=-15;
mout=mfh(s,cutoff);
jlout = jl_mat_call(jlfile, 'jlout=clipdb(s,cutoff)', {'jlout'}, {'s','cutoff'});
compare_mout_jlout(mout,jlout,tol,fstr,cleartestvars);


% fold
fstr='fold'; jlfile=fullfile(thispath,'filters.jl'); mfh=str2func(fstr);
N=16; s=randn(N,1)+1j*randn(N,1); 
mout=mfh(s); 
jlout = jl_mat_call(jlfile, 'jlout=fold(s)', {'jlout'}, {'s'});
compare_mout_jlout(mout,jlout,tol,fstr,cleartestvars);


% mps
fstr='mps'; jlfile=fullfile(thispath,'filters.jl'); mfh=str2func(fstr);
N=16; s=randn(N,1)+1j*randn(N,1); 
mout = mfh(s); 
jlout = jl_mat_call(jlfile, 'jlout=mps(s)', {'jlout'}, {'s'});
compare_mout_jlout(mout,jlout,tol,fstr,cleartestvars);


% grpdelay (1)
fstr='grpdelay'; jlfile=fullfile(thispath,'filters.jl'); mfh=str2func(fstr);
N=1024; b=randn(N,1); a=1; nfft=1024; whole='whole'; Fs=48000;
[mgd,mw] = mfh(b,a,nfft,whole,Fs); 
[jlgd, jlw] = jl_mat_call(jlfile, 'jlgd,jlw=grpdelay(b,a,nfft,whole,Fs)', ...
    {'jlgd','jlw'}, {'b','a','nfft','whole','Fs'});
compare_mout_jlout(mgd,jlgd,tol,[fstr,'-1-gd']);
compare_mout_jlout(mw ,jlw ,tol,[fstr,'-1-w']);

% grpdelay (2)
N=1024; b=randn(N,1);
[mgd,mw]=mfh(b);
[jlgd, jlw] = jl_mat_call(jlfile, 'jlgd,jlw=grpdelay(b)', {'jlgd','jlw'}, {'b'});
compare_mout_jlout(mgd,jlgd,tol,[fstr,'-2-gd']);
compare_mout_jlout(mw ,jlw ,tol,[fstr,'-2-w'],cleartestvars);



