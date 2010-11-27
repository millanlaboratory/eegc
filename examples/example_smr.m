% 2010-11-26  Michele Tavella <michele.tavella@epfl.ch>
mtpath_include('$EEGC3_ROOT/');					% Full eegc3
mtpath_include('$EEGC3_ROOT/modules/smr');		% SMR module
mtpath_include('$EEGC3_ROOT/modules/eegc2');	% eegc2 compatibility
mtpath_include('$EEGC3_ROOT/modules/cl');		% libcnbiloop hooks 

logfile = '~/Research/cnbi/mi/20101118_a2/';
%logfile = '~/Research/cnbi/eegc3/20101028_b3/';
session = eegc3_cl_loadlog(logfile);

if(isempty(session) == false)
	for i = 1:length(session.runs.online)
		if(session.trace.eegcversion == 2)
			bci = eegc3_smr_simloop(...
					session.runs.online{i}.xdf, ...
					session.runs.online{i}.txt, ...
					session.runs.online{i}.classifier, ...
					str2num(session.runs.online{i}.rejection), ... 
					str2num(session.runs.online{i}.integration), ...
					1000 + i);
		else
			bci = eegc3_smr_simloop(...
					session.runs.online{i}.xdf, ...
					[], ...
					session.runs.online{i}.classifier, ...
					str2num(session.runs.online{i}.r), ... 
					str2num(session.runs.online{i}.i), ...
					1000 + i);
		end

		[taskset, resetevents] = eegc3_smr_guesstask(bci.lbl);
		eegc3_smr_simprotocol(bci, taskset.cues, taskset.colors, ...
			[], [], 1, 2000 + i);
	end
end
