% 2010-12-10  Michele Tavella <michele.tavella@epfl.ch>
function F = eegc3_fs(d, k)

[N, D] = size(d);

k1 = find(k == 1);
k2 = find(k == 2);

m1 = mean(d(k1, :));
m2 = mean(d(k2, :));

s1 = std(d(k1, :));
s2 = std(d(k2, :));

F = abs(m2 - m1) ./ sqrt(s1.^2 + s2.^2);
