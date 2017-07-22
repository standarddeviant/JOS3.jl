% Obtained from https://ccrma.stanford.edu/~jos/filters/Group_Delay_Computation_grpdelay_m.html
function [gd,w] = grpdelay(b,a,nfft,whole,Fs) 

  if (nargin<1 || nargin>5)
    fprintf('usage of grpdelay:\n   %s', ... 
        '[g,w]=grpdelay(b [, a [, n [,''whole''[,Fs]]]])');
  end
  if nargin<5
    Fs=0; % return w in radians per sample
    
  if nargin<4, whole=''; 
  elseif ~isstr(whole)
    Fs = whole;
      whole = '';
  end
  if nargin<3, nfft=512; end
  if nargin<2, a=1; end
  end
  
  if strcmp(whole,'whole')==0, nfft = 2*nfft; end

  w = 2*pi*[0:nfft-1]/nfft;
  if Fs>0, w = Fs*w/(2*pi); end

  oa = length(a)-1;             % order of a(z)
  oc = oa + length(b)-1;        % order of c(z)
  c = conv(b,fliplr(a));	% c(z) = b(z)*a(1/z)*z^(-oa)
  cr = c.*[0:oc];               % derivative of c wrt 1/z 
  num = fft(cr,nfft);
  den = fft(c,nfft);
  minmag = 10*eps;
  polebins = find(abs(den)<minmag); 
  for b=polebins
    disp('*** grpdelay: group delay singular! setting to 0')
    num(b) = 0;
    den(b) = 1;
  end
  gd = real(num ./ den) - oa;
    
  if strcmp(whole,'whole')==0
    ns = nfft/2; % Matlab convention - should be nfft/2 + 1
    gd = gd(1:ns);
    w = w(1:ns);
  end

  w = w'; % Matlab returns column vectors
  gd = gd';