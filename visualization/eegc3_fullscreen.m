% 2011-01-21  Michele Tavella <michele.tavella@epfl.ch>
function eegc3_fullscreen(f)

if(nargin == 0)
	f = gcf();
end

if(strcmp(get(gcf, 'WindowStyle'), 'docked') == 0)
    ss = get(0, 'ScreenSize');
    set(f, 'Position', [0 0 ss(3) ss(4)]);
end