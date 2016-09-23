% Edited by M. Tavella <michele.tavella@epfl.ch> on 29/08/09 11:31:13
%
% function postprob = eegc2_bcidemo_classify(problem, buffer)
% 
% Where: postprob	vector with posterior probabilities [1 x classes]
% 
%        problem    structure created with eegc2_bcidemo_train
%        data       EEG window [points x channels]
% 
% Beware: if window size does not match [problem.dw x problem.numChs], 
%         an empty vector is returned

function [postprob, nfeature, afeature, rfeature] = eegc3_smr_bci(analysis, buffer)

% Preprocess EEG
sample = eegc3_smr_preprocess(buffer, ...
	analysis.options.prep.dc, ...
	analysis.options.prep.car, ...  
	analysis.options.prep.laplacian, ...
	analysis.settings.prep.laplacian);

% Feature extraction based on feature selection
if(nargout == 2)
	% If online:
	% - compute just the selected channels
	% - for each channel, return only the selected bands
	feature = eegc3_smr_features(sample, ...
		analysis.settings.eeg.fs, ...
		analysis.tools.features.bands, ...
		analysis.settings.features.psd.win, ...
		analysis.settings.features.psd.ovl, ...
		analysis.tools.features.channels);
elseif(nargout >= 3)
	% If offline:
	% - compute all the channels 
	% - for each channel, return all the bands (afeature)
	% - for each channel, extract only the selected channel/bands (feature)
	%   from afeature
    afeature = eegc3_smr_features(sample, ...
    	analysis.settings.eeg.fs, ...
        analysis.settings.features.psd.freqs, ...
    	analysis.settings.features.psd.win, ...
    	analysis.settings.features.psd.ovl, ...
    	1:analysis.settings.eeg.chs);

	feature = [];
	for ch = analysis.tools.features.channels
		bns = analysis.tools.features.bands{ch}; 
		for bni = bns
			bn = find(analysis.settings.features.psd.freqs == bni);
			feature = [feature; afeature(ch, bn)];
		end
	end
end

% 2010-11-27  Michele Tavella <michele.tavella@epfl.ch>
% TODO: discover what this does...
%
rfeature = feature';

% Feature scaling (Simis: to be avoided!!!)
if(analysis.options.classification.norm)
     nfeature = eegc3_smr_npsd(rfeature);
else
     nfeature = rfeature;
end

% Classification
[activations postprob] = gauClassifier(...
	analysis.tools.net.gau.M, ...
	analysis.tools.net.gau.C, ...
	nfeature);

