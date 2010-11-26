function support = eegserver_mi_new_support(analysis, rejection, integration)

fs = analysis.settings.eeg.fs;

support = {};
support.dist.uniform = ones(1,length(analysis.settings.task.classes))/...
    length(analysis.settings.task.classes);
support.dist.nan = nan(1, length(analysis.settings.task.classes));
support.dist.inf = inf(1, length(analysis.settings.task.classes));
support.packets = 0;
support.cprobs = support.dist.inf;
support.nprobs = support.dist.uniform;
support.rejection = rejection;
support.integration = integration;
