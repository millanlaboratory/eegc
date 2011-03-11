% 2011-03-11  Michele Tavella <michele.tavella@epfl.ch>
%
% function [S, P, f] = eegc3_fft(x, fs, bands)
function [S, P, f] = eegc3_fft(x, fs, bands)

m = length(x);          	% Window length
n = pow2(nextpow2(m));  	% Transform length
y = fft(x,n);           	% DFT
f = (0:n-1)*(fs/n);     	% Frequency range
y0 = fftshift(y);          	% Rearrange y values
f0 = (-n/2:n/2-1)*(fs/n);  	% 0-centered frequency range
p0 = y0.*conj(y0)/n;   	% 0-centered power
%h0 = unwrap(angle(y0)) * 180 / pi;
h0 = angle(y0);

%b0 = f0(fs/2+1:end);

[b1, i1] = intersect(f0, bands);

f = f0(i1);
S = p0(i1);
P = h0(i1);
