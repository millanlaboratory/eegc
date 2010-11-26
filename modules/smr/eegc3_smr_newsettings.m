function settings = eegc3_smr_smrsettings(settings)

settings.modules.smr.options.prep.dc  				= true;
settings.modules.smr.options.prep.car 				= false;
settings.modules.smr.options.prep.laplacian			= true;
settings.modules.smr.options.selection.dpt   		= false;
settings.modules.smr.options.selection.cva   		= true;
settings.modules.smr.options.selection.stability	= true;	
settings.modules.smr.options.selection.usegui		= true;
settings.modules.smr.options.classification.gau  	= true;

settings.modules.smr.montage = [0 0 1 0 0; ...
	 							1 1 1 1 1; ...
	 							1 1 1 1 1;...
     							1 1 1 1 1];
settings.modules.smr.laplacian = ...
	eegc3_montage(settings.modules.smr.montage);

settings.modules.smr.win.size 		= 1.00;
settings.modules.smr.win.shift		= 0.0625;

settings.modules.smr.psd.freqs		= [4:2:48];
settings.modules.smr.psd.win 		= 0.50;
settings.modules.smr.psd.ovl 		= 0.50;

settings.modules.smr.dp.threshold	= 0.50;

settings.modules.smr.gau.somunits 	= [2 2];
settings.modules.smr.gau.sharedcov 	= 't';
settings.modules.smr.gau.epochs 	= 20;
settings.modules.smr.gau.mimean		= 0.0001;
settings.modules.smr.gau.micov		= 0.00001;
settings.modules.smr.gau.th			= 0.70;
settings.modules.smr.gau.terminate	= true;

settings.bci.smr.channels  = [];
settings.bci.smr.bands     = {};
settings.bci.smr.gau.M   = [];
settings.bci.smr.gau.C   = [];
