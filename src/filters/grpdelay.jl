function grpdelay(b,a=1,nfft=512,whole="",Fs=0)
  if cmp(whole,"whole")==0; nfft = 2*nfft; end

  # this splatting behavior ensures a becomes a vector,
  # even if scalar is passed in
  b = [b...] # 'splatting', unfortunate but correct as of 0.6
  a = [a...] # 'splatting', unfortunate but correct as of 0.6
  nfft = Int(nfft)

  w = 2*pi*collect(0:nfft-1)/nfft;
  if Fs>0; w = Fs*w/(2*pi); end

  oa = length(a)-1;         # order of a(z)
  oc = oa + length(b)-1;    # order of c(z)
  c = conv(b,flipdim(a,1)); # c(z) = b(z)*a(1/z)*z^(-oa)
  cr = c .* collect(0:oc);    # derivative of c wrt 1/z
  num = fft( cat(1,cr,zeros(nfft-length(cr))) ,1); # nfft not supported :-\
  den = fft( cat(1,c ,zeros(nfft-length(c ))) ,1); # nfft not supported :-\
  minmag = 10*eps();
  polebins = find(abs(den) .< minmag);
  for b=polebins
    disp("*** grpdelay: group delay singular! setting to 0")
    num[b] = 0;
    den[b] = 1;
  end
  gd = real(num ./ den) - oa;

  if cmp(whole,"whole")==0
    ns = Int(nfft/2); # Matlab convention - should be nfft/2 + 1
    gd = gd[1:ns];
    w = w[1:ns];
  end

  w = reshape(vec(w),(length(w),1)); # Matlab returns column vectors
  gd = reshape(vec(gd),(length(gd),1)); # Matlab returns column vectors

  return (gd,w)
end