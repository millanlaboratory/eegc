function settings = eegc3_newsettings()

settings = {};

settings.info.subject 				= 'unknown';
settings.info.experimenter			= 'unknown';
settings.info.hostname				= 'unknown';
settings.info.date					= 'unknown';
settings.info.basename 				= 'unknown';

settings.acq.id                     = 0;
settings.acq.sf                     = 0;
settings.acq.channels_eeg			= 0;
settings.acq.channels_exg           = 0;
settings.acq.channels_tri           = 0;

settings.modules = {};
settings.bci = {};
