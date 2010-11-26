function [list_train, list_test] = eegc2_automake(basenames, pset, tset, grep)
% 2009-12-02  Michele Tavella <michele.tavella@epfl.ch>
%
% EEGC2_CNBI_AUTOMAKE is a wrapper to ease the dataset loading madness.
% It does not load by itself the datasets, it simply discovers where the files
% are stored (among a predefined set of paths) and returns two cell arrays (one
% for training, one for test) with the full path of the files. 
%
%    [FILELISTP, FILELISTT] = EEGC2_TOBI_AUTOMAKE(PATHS, PSET, TSET)
% 
%    Accepts:
%       PATHS      cell array 
%       PSET       array or cell array (check example)
%       TSET       array or cell array (check example)
%
%    Returns:
%       FILELISTP  TODO
%       FILELISTT  TODO
%
%     Examples:
%       1. Multi-experiment mode
%      	EEGC2_TOBI_AUTOMAKE({'BN1', 'BN2'}, [1], [2])
%       Tranlslated says: given two experiments (BN1 and BN2), give me back the
%       training set made up by all the sessions from experiment 1 and the
%       testing set made up by all the sessions from experiment 2.
% 
%       2. Single-experiment mode
%       EEGC2_TOBI_AUTOMAKE({'BN1'}, [1 2 3], [4])
%       Tranlslated says: given a single experiments (BN1), give me back the
%       training set made up by the first 3 sessions and the testing set made up
%       by the fourth session.
%
%       2. Mixed-experiment mode
%       EEGC2_TOBI_AUTOMAKE({'BN1', 'BN2'}, {[1 2 3], [1 2 3]}, {[4], [4]})
%       Tranlslated says: given two experiments (BN1 and BN2), give me back the
%       training set made up by session 1 to 3 from experiment 1 and session 1
%       to 3 from experiment 2.
% 		The training set is made up by session 4 from experiment 1 and 2.

if(nargin < 4)
	grep = '';
end

% Standard TOBI data folder at CNBI
autopaths{1} 		= '/mnt/backup/shared/data/';

% Custom Michele basenames
autopaths{end+1} 	= '/home/mtavella/Research';


% Checking if path recovery is needed
npaths = {};
for p = 1:length(basenames)
	if(~exist(basenames{p}, 'dir'))
		for ap = 1:length(autopaths)
			npath = [autopaths{ap} '/' basenames{p} '/' ];
			strrep(npath, '//', '/');
			if(exist(npath, 'dir'))
				npaths{p} = npath;
			end
		end
	end
end
if(length(npaths) == length(basenames))
	disp('[eegc2_automake] Paths automagically recovered');
	basenames = npaths;
end


% Operation modes. 
MODE_SINGLE = 0;
MODE_MULTI = 1;
MODE_MIXED = 2;
opt_mode = MODE_SINGLE;

if(length(basenames) > 1)
	if(iscell(pset) && iscell(tset))
		disp('[eegc2_automake] Running in Mixed-Experiment mode');
		opt_mode  = MODE_MIXED;
	else
		disp('[eegc2_automake] Running in Multi-Experiment mode');
		opt_mode  = MODE_MULTI;
	end
else
	disp('[eegc2_automake] Running in Single-Experiment mode');
	opt_mode  = MODE_SINGLE;
end

% Spoil the user: automagically complete the tset and pset arrays
if(opt_mode == MODE_MULTI)
	if(~isempty(pset) & isempty(tset))
		disp('[eegc2_automake] Autocompleting T paths');
		tset = setdiff([1:1:length(basenames)], pset);
	end
	if(~isempty(tset) & isempty(pset))
		disp('[eegc2_automake] Autocompleting T paths');
		pset = setdiff([1:1:length(basenames)], tset);
	end
end

% Create dataset structures for training and test
list.train = {};
list.test = {};
for pidx = 1:length(basenames)
	disp('[eegc2_automake] Scanning: ');
	disp([' ' basenames{pidx}]);

	files = dir([basenames{pidx} '/*' grep '*.gdf']);
	
	disp('[eegc2_automake] May the force be with you:');
	for bnidx = 1:length(files)
		gdffile = files(bnidx).name;

		switch(opt_mode)
			case MODE_MULTI
				if(find(pset == pidx))
					list.train{end+1} = [basenames{pidx} '/' gdffile];
					disp([ ' ' num2str(bnidx) ': '  gdffile ' (P)']);
				end

				if(find(tset == pidx))
					list.test{end+1} = [basenames{pidx} '/' gdffile];
					disp([ ' ' num2str(bnidx) ': '  gdffile ' (T)']);
				end
			
			case MODE_SINGLE
				if(find(pset == bnidx))
					list.train{end+1} = [basenames{pidx} '/' gdffile];
					disp([ ' ' num2str(bnidx) ': '  gdffile ' (P)']);
				end

				if(find(tset == bnidx))
					list.test{end+1} = [basenames{pidx} '/' gdffile];
					disp([ ' ' num2str(bnidx) ': '  gdffile ' (T)']);
				end
	
			case MODE_MIXED
				if(find(pset{pidx} == bnidx))
					list.train{end+1} = [basenames{pidx} '/' gdffile];
					disp([ ' ' num2str(bnidx) ': '  gdffile ' (P)']);
				end

				if(find(tset{pidx} == bnidx))
					list.test{end+1} = [basenames{pidx} '/' gdffile];
					disp([ ' ' num2str(bnidx) ': '  gdffile ' (T)']);
				end

			otherwise
				disp('[eegc2_automake] Error: kicked by Chuck Norris');
		end
		
	end
end

list_train = list.train;
list_test = list.test;
