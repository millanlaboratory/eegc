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
mtpath_include([basename '/management/']);
mtpath_include([basename '/performances/']);
mtpath_include([basename '/preprocessing/']);
mtpath_include([basename '/testtools/']);
mtpath_include([basename '/tools/']);
mtpath_include([basename '/visualization/']);
