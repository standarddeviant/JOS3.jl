function fold(r)
# [rw] = fold(r)

# Fold left wing of vector in "FFT buffer format"
# onto right wing
# J.O. Smith, 1982-2002

   sz = size(r);
   n = maximum(sz)
   if prod(sz) != n
     error("fold.m: input must be a vector");
   end

   if n < 3; return r;
   elseif mod(n,2)==1
       nt = Int((n+1)/2);
       rw = [ r[1], r[2:nt] + conj(r[n:-1:nt+1]), 0*ones(n-nt) ];
   else
       nt = Int(n/2);
       rf = cat(1, r[2:nt] , 0);
       rf = rf + conj(r[n:-1:nt+1]);
       rw = cat(1, r[1] , rf , 0*ones(n-nt-1) );
   end

   rw = reshape(rw,sz)
   return rw
end
