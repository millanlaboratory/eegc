function bci = eegc3_smr_simloop(filexdf, filetxt, filemat, ... 
	rejection, integration, doplot, resetevents)
% 2010-11-05  Michele Tavella <michele.tavella@epfl.ch>
% TODO Add call info

if(nargin < 6)
	doplot = false;
end
if(nargin < 7)
	% These events are defaulted for SMR BCI:
	%   781		Continuos Feedback
	%   897		Target hit
	%   898		Target miss
	resetevents = [781 898 897];
end

% Create extra/ directory
[extra.directory, extra.basename] = eegc3_mkextra(filexdf, 'eegc3');

% Inialize BCI structure
bci = eegc3_smr_newbci();
bci.trace.eegc3_smr_simloop.datetime    = eegc3_datetime();
bci.trace.eegc3_smr_simloop.filexdf     = filexdf;
bci.trace.eegc3_smr_simloop.filetxt     = filetxt;
bci.trace.eegc3_smr_simloop.rejection   = rejection;
bci.trace.eegc3_smr_simloop.integration = integration; 
bci.trace.eegc3_smr_simloop.resetvents  = resetevents; 
bci.trace.eegc3_smr_simloop.filemat		= ...
	strrep([extra.directory '/' extra.basename], '.gdf', '.simloop.mat');
bci.trace.eegc3_smr_simloop.figbasename = ...
	strrep([extra.directory '/' extra.basename], '.gdf', '');

printf('[eegc3_smr_simloop] Running simulated SMR-BCI loop:\n');
printf(' < GDF:         %s\n', bci.trace.eegc3_smr_simloop.filexdf);
printf(' < TXT:         %s\n', bci.trace.eegc3_smr_simloop.filetxt);
printf(' > MAT:         %s\n', bci.trace.eegc3_smr_simloop.filemat);
printf(' - Rejection:   %f\n', bci.trace.eegc3_smr_simloop.rejection);
printf(' - Integration: %f\n', bci.trace.eegc3_smr_simloop.integration);

if(exist(bci.trace.eegc3_smr_simloop.filemat, 'file'))
	printf('[eegc3_smr_simloop] Loading precomputed MAT: %s\n', ...
		bci.trace.eegc3_smr_simloop.filemat);
	load(bci.trace.eegc3_smr_simloop.filemat);
	return;
end

% Import all the data we need
printf('[eegc3_smr_simloop] Loading GDF/TXT files... ');
[data.eeg, data.hdr] = sload(filexdf);
if(isempty(filetxt) == false)
	data.aprobs = importdata(filetxt);
	data.cprobs = data.aprobs(:, 1:2);
	data.iprobs = data.aprobs(:, 3:4);
end
printf('Done!\n');

% Extract trigger informations
data.lpt = data.eeg(:, end);
data.lpt(find(data.lpt > 1)) = 1;		% To be changed = 0
data.evt = gettrigger(data.lpt);
data.red = zeros(1, size(data.eeg,1));
data.red(data.evt) = 1;
data.lbl = data.hdr.EVENT.TYP;

% Set up simulated BCI
bci.analysis = load(filemat);
bci.analysis = bci.analysis.analysis;
bci.eeg = ndf_ringbuffer(bci.analysis.settings.eeg.fs, ...
	bci.analysis.settings.eeg.chs, 1);
bci.tri = ndf_ringbuffer(bci.analysis.settings.eeg.fs, 1, 1);
bci.support = eegc3_smr_newsupport(bci.analysis, rejection, integration);
bci.frames = bci.analysis.settings.features.win.shift* ...
		bci.analysis.settings.eeg.fs;
bci.framet = size(data.eeg, 1) / bci.frames;
bci.cprobs = [];	% Classifier oputput
bci.iprobs = [];	% Integrated probabilities
bci.afeats = nan(bci.framet, ...
	length(bci.analysis.settings.features.psd.freqs), ...
	bci.analysis.settings.eeg.chs);
bci.nfeats = nan(bci.framet, ...
	size(bci.analysis.tools.net.gau.M, 3));
bci.evt = [];		% LPT Trigger position (in frames) 
bci.trg = [];		% LPT Trigger value (TODO)
bci.lbl = [];		% GDF label event
bci.Sf = bci.analysis.settings.eeg.fs/bci.frames;
bci.t = mt_support(0, bci.framet, bci.Sf);

% Temporary data structures for simulating the loop
tmp.framed = [];	% EEG frame
tmp.nfeat  = [];	% PSD feature
tmp.afeat  = [];	% PSD feature
tmp.framep = 1;		% Pointer to EEG frame
tmp.frame0 = -1;	% Starting sample for current frame
tmp.frame1 = -1;	% Ending sample for current frame

% Check for frame mismatch
align = {};
align.notaligned = false;
if(isempty(filetxt) == false)
	align.eeg = size(data.eeg, 1)/bci.frames;
	align.prb = size(data.aprobs, 1);
	align.delta = align.eeg-align.prb;
	printf('[eegc3_smr_simloop] Mismatch: EEG/PRB = %d/%d, Delta=%d\n', ...
		align.eeg, align.prb, align.delta);

	if(align.delta)
		printf('[eegc3_smr_simloop] Error: mismatch detected');
		align.notaligned = true;
	end
end

% Simulate BCI loop
trgdetect = [];
for i = 1:1:bci.framet
	mt_progress('[eegc3_smr_simloop] Simulating SMR-BCI', i, 1, bci.framet);
	
	% Get EEG frame
	tmp.framep = i;
	tmp.frame0 = bci.frames * (tmp.framep - 1) + 1;
	tmp.frame1 = bci.frames * tmp.framep;
	tmp.framed = data.eeg(tmp.frame0:tmp.frame1, :);

	% Classify EEG frame
	bci.eeg = ndf_add2buffer(bci.eeg, tmp.framed(:,1:end-1));
	bci.tri = ndf_add2buffer(bci.tri, tmp.framed(:,end));
	%bci.support = eegserver_mi_buffer_support(bci.support, tmp.framed);
	[bci.support, tmp.nfeat, tmp.afeat] = ...
		eegc3_smr_classify(bci.analysis, bci.eeg, bci.support);
	
	% Add features to BCI structure if not empty
	if(isempty(tmp.nfeat) == false)
		bci.nfeats(tmp.framep, :) = tmp.nfeat;
	end
	if(isempty(tmp.afeat) == false)
		% TODO
		% Problem: I need to transpose because eegserver_mi_classify returns 
		%	[Ch x Freqs]
		% Solution: eegserver_mi_classify should return:
		%	[Freqs x Ch]
		bci.afeats(tmp.framep, :, :) = tmp.afeat';
	end
	bci.cprobs(end+1, :) = bci.support.cprobs;
	bci.iprobs(end+1, :) = bci.support.nprobs;
	
	% Check for raising edges in current frame
	trgdetect.tnow = length(find(data.red(tmp.frame0:tmp.frame1) == 1));
	if(trgdetect.tnow == 1)
		bci.evt(end+1) = tmp.framep;
		bci.lbl(end+1) = data.lbl(length(bci.evt));
		if(find(resetevents == bci.lbl(end)))
			bci.support.nprobs = bci.support.dist.uniform;
		end
	elseif(trgdetect.tnow > 1)
		printf('[eegc3_smr_simloop] Found >1 trigger in a single frame!\n');
		return;
	end

	mt_progressclean();
	if(tmp.frame1 >= size(data.eeg, 1))
		break;
	end
end

if(doplot && isempty(filetxt) == false && align.notaligned == false);
	eegc3_figure(doplot);
		subplot(4, 1, 1:2)
			plot(bci.t, data.cprobs(:, 1), 'ko');
			hold on;
			plot(bci.t, bci.cprobs(:, 1), 'r.');
			hold off;
			legend('TXT', 'GDF')
			ylim([0 1]);
			xlim([bci.t(1) bci.t(end)]);
			grid on;
			ylabel('Cprobs TXT/GDF');
		subplot(4, 1, 3)
			plot(bci.t, (bci.cprobs(:,1) - data.cprobs(:,1)), 'k')
			ylim([-1 +1]);
			xlim([bci.t(1) bci.t(end)]);
			grid on;
			xlabel('Time [s]');
			ylabel('Cprobs delta');
		subplot(4, 1, 4)
			imagesc(flipud(bci.nfeats'));
			xlabel('EEG frames');
		drawnow;
	eegc3_figure(doplot, 'print', ...
		[bci.trace.eegc3_smr_simloop.figbasename '.simloop.png']);
end

printf('[eegc3_smr_simloop] Saving SMR-BCI structure: %s\n', ...
	bci.trace.eegc3_smr_simloop.filemat);
save(bci.trace.eegc3_smr_simloop.filemat, 'bci');
