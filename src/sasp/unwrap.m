% Obtained from https://ccrma.stanford.edu/~jos/sasp/Matlab_listing_unwrap_m.html
function up = unwrap(p)
%UNWRAP unwrap phase

N = length(p);
up = zeros(size(p));
pm1 = p(1);
up(1) = pm1;
po = 0;
thr = pi - eps;
pi2 = 2*pi;
for i=2:N
    cp = p(i) + po;
    dp = cp-pm1;
    pm1 = cp;
    if dp>thr
        while dp>thr
            po = po - pi2
            dp = dp - pi2;
        end
    end
    if dp<-thr
        while dp<-thr
            po = po + pi2
            dp = dp + pi2;
        end
    end
    cp = p(i) + po;
    pm1 = cp;
    up(i) = cp;
end