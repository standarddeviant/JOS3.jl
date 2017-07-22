function mps(s)
# create minimum-phase spectrum sm from complex spectrum s
   return exp( fft( fold( ifft( log( clipdb(complex(s),-100) )))));
end
