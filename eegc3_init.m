% 2010-11-11  Michele Tavella <michele.tavella@epfl.ch>
% Import all directories but modules
[file, basename] = mtpath_basename(which('eegc3_init'));

mtpath_include('$EEGC3_ROOT/apps/');
mtpath_include('$EEGC3_ROOT/classification/');
mtpath_include('$EEGC3_ROOT/configuration/');
mtpath_include('$EEGC3_ROOT/dataset/');
mtpath_include('$EEGC3_ROOT/featureextraction/');
mtpath_include('$EEGC3_ROOT/featureselection/');
mtpath_include('$EEGC3_ROOT/gui/');
mtpath_include('$EEGC3_ROOT/inputoutput/');
mtpath_include('$EEGC3_ROOT/integration/');
mtpath_include('$EEGC3_ROOT/management/');
mtpath_include('$EEGC3_ROOT/performance/');
mtpath_include('$EEGC3_ROOT/preprocessing/');
mtpath_include('$EEGC3_ROOT/tools/');
mtpath_include('$EEGC3_ROOT/visualization/');

% Need to reshape this stuff
warning('off','MATLAB:dispatcher:InexactCaseMatch');
mtpath_include('$EEGC3_INCLUDES/xml4mat');
mtpath_include('$EEGC3_INCLUDES/gaussian');
mtpath_include('$EEGC3_INCLUDES/cva');
mtpath_include('$EEGC3_INCLUDES/gdfmatlab');
mtpath_include('$EEGC3_INCLUDES/gkde');
mtpath_include('$EEGC3_INCLUDES/biosig');
mtpath_include('$EEGC3_INCLUDES/biosig/t200');
mtpath_include('$EEGC3_INCLUDES/biosig/t250');
mtpath_include('$EEGC3_INCLUDES/biosig/t300');
mtpath_include('$EEGC3_INCLUDES/biosig/t400');
mtpath_include('$EEGC3_INCLUDES/biosig/t490');
mtpath_include('$EEGC3_INCLUDES/biosig/t500');
warning('on','MATLAB:dispatcher:InexactCaseMatch');
