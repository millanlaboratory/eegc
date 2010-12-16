% 2010-12-07  Michele Tavella <michele.tavella@epfl.ch>
function eegc3_dpplot(f, M, channels, bands, plotcb)

if(nargin == 2)
	channels = [1:1:16];
	bands = [4:2:48];
end

if(nargin < 5)
    plotcb = false;
end

eegc3_figure(f);
imagesc(M, [0 1]);
set(gca, 'YTick',      [1:1:length(channels)]);
set(gca, 'YTickLabel', channels);
set(gca, 'XTick',      [1:1:length(bands)]);
set(gca, 'XTickLabel', bands);
xlabel('Band [Hz]');
ylabel('Channel');
colormap(1-gray);
if(plotcb)
    colorbar;
end
