% 2010-11-10  Michele Tavella <michele.tavella@epfl.ch>
% TODO
function eegc3_smr_simprotocol(bci, cues, cuecolors, thresholds, doplot);
%	revents, eventcolors, doplot)

% These events are defaulted for SMR BCI:
%   781		Continuos Feedback
%   897		Target hit
%   898		Target miss
% For this reason, here we have some ROIs
roi.hits = bci.evt(find(bci.lbl == 897));
roi.miss = bci.evt(find(bci.lbl == 898));
roi.cfbk = bci.evt(find(bci.lbl == 781));

if(isempty(cues))
	printf('[eegc3_smr_simprotocol] Guessing cues: ');
	cues = setdiff(unique(bci.lbl), [897 898 781]);
	cuecolors = {};
	for i = 1:length(cues)
		printf('%d ', cues(i));
		cuecolors{end+1} = 'k';
	end
	printf('\n');
end

if(isempty(thresholds))
	printf('[eegc3_smr_simprotocol] Guessing thresholds: ');
	thresholds(1) = mean(bci.iprobs(roi.hits(bci.iprobs(roi.hits) > 0.5)));
	thresholds(2) = 1 - mean(bci.iprobs(roi.hits(bci.iprobs(roi.hits) < 0.5)));
	
	for i = 1:length(thresholds)
		printf('%f ', thresholds(i));
	end
	printf('\n');
end

if(doplot == false)
	return;
end

if(doplot)
	eegc2_figure(doplot);
	plot(bci.t, bci.cprobs(:, 1), 'r.');
	hold on;
	plot(bci.t, bci.iprobs(:, 1), 'k.');
	hold off;
	ylim([0 1]);
	xlim([bci.t(1) bci.t(end)]);
	grid on;
	drawnow;

	eegc3_smr_barh(0.5, 'k', 1);
	eegc3_smr_barh(thresholds(1), 'k', 1);
	eegc3_smr_barh(1-thresholds(2), 'k', 1);

	% Draw target hit
	for i = 1:length(roi.hits)
		eegc3_smr_barv(roi.hits(i)/bci.Sf, 'g', 2);
	end
	% Draw target miss 
	for i = 1:length(roi.miss)
		eegc3_smr_barv(roi.miss(i)/bci.Sf, 'r', 2);
	end
	% Draw continuos feedback
	for i = 1:length(roi.cfbk)
		eegc3_smr_barv(roi.cfbk(i)/bci.Sf, 'k', 1);
	end
	% Draw cues
	for j = 1:length(cues)
		roi.cues{j} = bci.evt(find(bci.lbl ==  cues(j)));
		for i = 1:length(roi.cues{j})
			eegc3_smr_barv(roi.cues{j}(i)/bci.Sf, cuecolors{j}, 2);
		end
	end

	ylim([-0.05 +1.05]);
	% Draw target hit
	for i = 1:length(roi.hits)
		text(roi.hits(i)/bci.Sf, -0.015, 'h', 'HorizontalAlignment', 'center');
	end
	% Draw target miss 
	for i = 1:length(roi.miss)
		text(roi.miss(i)/bci.Sf, -0.015, 'm', 'HorizontalAlignment', 'center');
	end
	%% Draw continuos feedback
	for i = 1:length(roi.cfbk)
		text(roi.cfbk(i)/bci.Sf, -0.015, 'c', 'HorizontalAlignment', 'center');
	end
	% Draw cues
	for j = 1:length(cues)
		roi.cues{j} = bci.evt(find(bci.lbl ==  cues(j)));
		for i = 1:length(roi.cues{j})
			text(roi.cues{j}(i)/bci.Sf, 1.015, num2str(cues(j)), ...
				'HorizontalAlignment', 'center');
		end
	end
	% Draw trial lines
	roi.trial0 = sort([roi.cues{1} roi.cues{2}]);
	roi.trial1 = sort([roi.hits roi.miss]);
	for i = 1:length(roi.trial0)
		eegc3_smr_bart([roi.trial0(i) roi.trial1(i)]/bci.Sf);
	end
	kk
	eegc2_figure(doplot, 'print', ...
		[bci.trace.eegc3_smr_simloop.figbasename '.simprotocol.png']);
end
