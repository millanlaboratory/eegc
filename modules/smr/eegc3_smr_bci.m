% Edited by M. Tavella <michele.tavella@epfl.ch> on 29/08/09 11:31:13
%
% function postprob = eegc2_bcidemo_classify(problem, data)
% 
% Where: postprob	vector with posterior probabilities [1 x classes]
% 
%        problem    structure created with eegc2_bcidemo_train
%        data       EEG window [points x channels]
% 
% Beware: if window size does not match [problem.dw x problem.numChs], 
%         an empty vector is returned

function postprob = eegc2_smr_bci(analysis, data)

if(nargin < 2)
	data = rand(512, 16);
end

% Preprocess EEG
sample = eegc3_smr_preprocess(data, ...
	analysis.options.prep.dc, ...
	analysis.options.prep.car, ...  
	analysis.options.prep.laplacian, ...
	analysis.settings.prep.laplacian);

% Feature extraction based on feature selection
pattern = eegc3_smr_features(sample, ...
	analysis.settings.eeg.fs, ...
	analysis.tools.features.bands, ...
	analysis.settings.features.psd.win, ...
	analysis.settings.features.psd.ovl, ...
	analysis.tools.features.channels);

% Feature normalization
npattern = eegc3_smr_npsd(pattern');

% Classification
[activations postprob] = gauClassifier(...
	analysis.tools.net.gau.M, ...
	analysis.tools.net.gau.C, ...
	npattern);
