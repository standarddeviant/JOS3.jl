# Adapted from https://ccrma.stanford.edu/~jos/filters/Parallel_SOS_Transfer_Function.html

function psos2tf(sos,g=1)
    nsecs = size(sos,1)
    if nsecs<1, B=[]; A=[]; return; end

    Bs = sos[:,1:3];
    As = sos[:,4:6]; 
    B = Bs[1,:];  
    A = As[1,:];

    for i=2:nsecs
        B = conv(B,As[i,:]) + conv(A,Bs[i,:]);
        A = conv(A,As[i,:]);
    end
    return [B,A]
end # function