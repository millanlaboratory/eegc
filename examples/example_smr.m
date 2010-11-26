% 2010-11-26  Michele Tavella <michele.tavella@epfl.ch>
mtpath_include('$EEGC3_ROOT/');					% Full eegc3
mtpath_include('$EEGC3_ROOT/modules/smr');		% SMR module
mtpath_include('$EEGC3_ROOT/modules/eegc2');	% eegc2 compatibility
mtpath_include('$EEGC3_ROOT/modules/cl');		% libcnbiloop hooks 

logfile = '~/Research/cnbi/mi/20101118_a2/a2_20101118.log';
session = eegc3_cl_loadlog(logfile);
