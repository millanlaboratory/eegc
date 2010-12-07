% 2010-12-05  Michele Tavella <michele.tavella@epfl.ch>
%
% S is [Time x Bands x Channels]
% Ts is [Time x Bandx x Channels x Trials]
% poi is [N x 1] in fames/samples
% dur is [1 x 1] in frames/samples

function Ts = eegc3_smr_gettrials(S, poi, dur)

[T, B, C] = size(S);
N = length(poi);
Ts = nan(dur, B, C, N);

for n = 1:N
	Ts(:, :, :, n) = S(poi(n):poi(n)+dur-1, :, :);
end
