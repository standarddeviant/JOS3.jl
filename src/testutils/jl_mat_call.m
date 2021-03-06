function varargout = jl_mat_call(jlfile, jlevalstr, jlouts, jlins)
    % make temp directory to stash files as variables
    tdir=tempname(); mkdir(tdir);
    
    % load matlab input variables as ra files for julia input
    for jli = jlins
        tmpval = evalin('base',char(jli)); % grab value from base
        eval([ char(jli) , ' = tmpval;']);
    end
    if ~isempty(jlins)
        save(fullfile(tdir,'input.mat'), jlins{:}, '-v7');
    end
    
    % (0) construct julia script to execute function call
    jlspath = fullfile(tdir,'script.jl'); % make julia script path
    jls = fopen(jlspath, 'w');            % make julia script file

    % (1) use MAT and include jlfile
    fprintf(jls, 'using MAT;\n');     % load raread/rawrite
    if ~isempty(jlfile)
        fprintf(jls, 'include(raw"%s");\n', jlfile);
    end
    
    % (2) load mat file to julia env
    if ~isempty(jlins)
        fprintf(jls, '_din = matread(raw"%s");\n', fullfile(tdir, 'input.mat'));
        fprintf(jls, '%s\n','for k in keys(_din); eval(parse("$(k) = _din[\"$(k)\"]")); end;');
        %fprintf(jls, 'for k in keys(_din); @eval ($(Symbol(k)) = _din[k]); end;\n');
    end

    % (3) call eval str
    fprintf(jls, '%s;\n', jlevalstr);

    % (4) write julia output variables as mat file for matlab output
    fprintf(jls, '_dout = Dict()\n');
    for jlo = jlouts
        fprintf(jls, '_dout["%s"] = %s;\n', char(jlo), char(jlo));
    end
    fprintf(jls, 'matwrite(raw"%s", _dout);\n', fullfile(tdir, 'output.mat'));
    % (5) exit julia script
    fprintf(jls, 'exit();\n');
    % (6) close julia script file
    fclose(jls);
    
    % run julia script
    jlevalcmd = sprintf('julia --depwarn=no --load "%s"',jlspath);
    system(jlevalcmd);
    
    % load output mat file to varargout
    varargout = cell(length(jlouts),1);
    voidx = 0;
    load(fullfile(tdir, 'output.mat'));
    for jlo = jlouts
        voidx = voidx + 1;
        varargout{voidx} = eval(char(jlo));
    end
    
    % clean up temp directory
    if exist('confirm_recursive_rmdir')
        confirm_recursive_rmdir(0)
    end
    rmdir(tdir,'s'); % s option is like 'rm -rf', but docs don't say what s means...
end % function
