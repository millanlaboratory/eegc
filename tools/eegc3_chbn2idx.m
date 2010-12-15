% 2010-12-15  Michele Tavella <michele.tavella@epfl.ch> 
function [ichannel, iband, labels, total] = eegc3_chbn2idx(schannels, sbands, channels, bands)

ichannel = [];
iband = [];
labels = {};

if(nargin == 1)
	analysis = schannels;
	channels = [1:1:analysis.settings.eeg.chs];
	bands = analysis.settings.features.psd.freqs;
	schannels = analysis.tools.features.channels;
	sbands = analysis.tools.features.bands;
end

total = 0;
for c = schannels
	freqs = sbands{c};
	for f = freqs
		b = find(bands == f);
		ichannel(end+1) = c;
		iband(end+1) = b;
		labels{end+1} = sprintf('Ch. %d, %d Hz', c, b);
        total = total + 1;
	end
end
