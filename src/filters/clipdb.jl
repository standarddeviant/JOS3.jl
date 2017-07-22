function clipdb(s,cutoff)
  # [clipped] = clipdb(s,cutoff)
  # Clip magnitude of s at its maximum + cutoff in dB.
  # Example: clip(s,-100) makes sure the minimum magnitude
  # of s is not more than 100dB below its maximum magnitude.
  # If s is zero, nothing is done.

  as = abs(s);
  mas = maximum(as);
  if mas==0; return; end
  if cutoff >= 0; return; end

  thresh = mas*10^(cutoff/20); # db to linear
  clipped = float(s);
  clipped[ as .< thresh ] = thresh;
  return clipped;
end
