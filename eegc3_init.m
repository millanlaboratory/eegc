% 2010-11-11  Michele Tavella <michele.tavella@epfl.ch>
% Import all directories but modules
[file, basename] = mtpath_basename(which('eegc3_init'));

mtpath_include([basename '/apps/']);
mtpath_include([basename '/classification/']);
mtpath_include([basename '/configuration/']);
mtpath_include([basename '/dataset/']);
mtpath_include([basename '/featureextraction/']);
mtpath_include([basename '/featureselection/']);
mtpath_include([basename '/gui/']);
mtpath_include([basename '/inputoutput/']);
mtpath_include([basename '/integration/']);
mtpath_include([basename '/management/']);
mtpath_include([basename '/performance/']);
mtpath_include([basename '/preprocessing/']);
mtpath_include([basename '/tools/']);
mtpath_include([basename '/visualization/']);

% Need to reshape this stuff
warning('off','MATLAB:dispatcher:InexactCaseMatch');
mtpath_include('$CNBI_ROOT/Projects/Classification/Gaussian');
mtpath_include('$CNBI_ROOT/Projects/FeatureSelection/CVA');
mtpath_include('$CNBI_ROOT/Projects/gdfmatlab');
mtpath_include('$CNBI_ROOT/Thirdparty/matlab/gkde');
mtpath_include('$CNBI_ROOT/Thirdparty/matlab/biosig');
mtpath_include('$CNBI_ROOT/Thirdparty/matlab/biosig/t200');
mtpath_include('$CNBI_ROOT/Thirdparty/matlab/biosig/t250');
mtpath_include('$CNBI_ROOT/Thirdparty/matlab/biosig/t300');
mtpath_include('$CNBI_ROOT/Thirdparty/matlab/biosig/t400');
mtpath_include('$CNBI_ROOT/Thirdparty/matlab/biosig/t490');
mtpath_include('$CNBI_ROOT/Thirdparty/matlab/biosig/t500');
warning('on','MATLAB:dispatcher:InexactCaseMatch');
