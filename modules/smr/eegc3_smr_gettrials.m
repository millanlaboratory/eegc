% 2010-12-05  Michele Tavella <michele.tavella@epfl.ch>
%
% S is [Time x Bands x Channels]
% St is [Time x Bandx x Channels x Trials]

function [St, t] = eegc3_smr_gettrials(S, Sf, dt, poi)

dur = round(dt*Sf);
t = mt_support(0, dur, Sf);

[T, B, C] = size(S);
N = length(poi);
St = nan(dur, B, C, N);

for n = 1:N
	St(:, :, :, n) = S(poi(n):poi(n)+dur-1, :, :);
end
