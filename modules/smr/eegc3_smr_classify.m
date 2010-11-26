% - Initially written by Michele
% - Then modified by Simis who casted the Perdikisian spells in this file
% - Then corrected and integrated in eegemg by Michele
% - Finally approved by Chuck Norris
function support = eegserver_mi_classify(analysis, support)

fs = analysis.settings.eeg.fs;

% Increase the packet number
%support.packets = support.packets + 1;
% Add the received data to the classifying support
%support.eeg = [support.eeg(size(data, 1) + 1:end, :); double(data)];

% If the classifier support is partially filled, pass control to next iteration
if(support.packets < ...
        (analysis.settings.features.win.size*fs) / ...
        (analysis.settings.features.win.shift*fs))
    % Not enough data: support.postprobs and support.probs keeps theie value
    %disp(['Skipping: ' num2str(support.packets)]);
    return;
else    
    support.probs = eegc2_onlineclassifier(analysis, ...
        support.eeg(end-analysis.settings.features.win.size*fs+1:end, ...
        1:analysis.settings.eeg.chs));
    
    % Hack for bias
    %bias = 0.0;
    %support.probs = support.probs + [bias, 0];
    %support.probs = support.probs / sum(support.probs);
    
    if(support.rejection > 0)
        if(max(support.probs) < support.rejection)
            %support.probs = uniform;
            %support.probs = (support.probs + support.dist.uniform)/2;
            support.probs = support.postprobs;
        end
    end
    
    if(support.integration > 0)
        % Perdikisian Integration
        support.postprobs = ...
            eegc2_integration(support.postprobs, support.probs, ...
            support.integration);
        %disp([support.probs support.postprobs]);
    else
        support.postprobs = support.probs;
    end
end
