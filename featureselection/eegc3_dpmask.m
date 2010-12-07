% 2010-12-07  Michele Tavella <michele.tavella@epfl.ch>

function [M, Mall] = eegc3_dpmask(schannels, sbands, channels, bands)

if(nargin == 2)
	channels = [1:1:16];
	bands = [4:2:48];
end

if(nargin == 1)
	analysis = schannels;
	channels = [1:1:analysis.settings.eeg.chs];
	bands = analysis.settings.features.psd.freqs;
	schannels = analysis.tools.features.channels;
	sbands = analysis.tools.features.bands;
end

M = zeros(length(channels), length(bands));
Mall = ones(length(channels), length(bands));
for c = schannels
	freqs = sbands{c};
	for f = freqs
		M(c, find(bands == f)) = 1;
	end
end
