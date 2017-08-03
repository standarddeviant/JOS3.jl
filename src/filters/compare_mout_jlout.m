function compare_mout_jlout(mout,jlout,tol,fstr,cleartestvars)
    if nargin < 5; cleartestvars=''; end;
    if any( abs( mout - jlout ) > tol )
        error('FAILED: %s failed tolerance test\n', fstr);
    else
        fprintf('PASSED: %s\n',fstr);
    end
    eval(cleartestvars);
end