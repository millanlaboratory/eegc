% 2010-11-27  Michele Tavella <michele.tavella@epfl.ch>
function [taskset, resetevents] = eegc3_smr_guesstask(labels)

taskset = [];
resetevents = [];

[cues, protocol] = eegc3_smr_newevents();

ulabels = unique(labels);

has.cfeedbackoff  = false;
has.cfeedback  = false;
has.targetmiss = false;
has.targethit  = false;
has.inc        = false;

for l = ulabels
	has.cfeedback = has.cfeedback || (l == protocol.cfeedback);
	has.cfeedbackoff = has.cfeedbackoff || (l == protocol.cfeedbackoff);
	has.targethit = has.targethit || (l == protocol.targethit);
	has.targetmiss = has.targetmiss || (l == protocol.targetmiss);
	has.inc = has.inc || (l == protocol.inc);
end

printf('[eegc3_smr_guesstask] Guessing protocol: ');
if(has.cfeedback)
	if(has.targethit || has.targetmiss)
		if(has.inc)
			printf('INC online\n');
			resetevents = ...
				[protocol.cfeedback protocol.targethit protocol.targetmiss];
		else
			printf('SMR online\n');
			resetevents = ...
				[protocol.cfeedback protocol.targethit protocol.targetmiss];
		end
	end
	if(has.cfeedbackoff)
		printf('SMR offline [eegc v2]\n');
	end
else
	printf('SMR offline [eegc v2]\n');
end


did.right_hand_mi 	= false;
did.left_hand_mi 	= false;
did.both_hands_mi 	= false;
did.both_feet_mi 	= false;
did.rest_mi 		= false;
did.inc             = false;

for l = ulabels
	did.right_hand_mi 	= did.right_hand_mi || (l == cues.right_hand_mi);
	did.left_hand_mi 	= did.left_hand_mi || (l == cues.left_hand_mi);
	did.both_hands_mi 	= did.both_hands_mi || (l == cues.both_hands_mi);
	did.both_feet_mi 	= did.both_feet_mi || (l == cues.both_feet_mi);
	did.rest_mi 		= did.rest_mi || (l == cues.rest_mi);
    did.inc     		= did.inc || (l == cues.inc);
end

printf('[eegc3_smr_guesstask] Guessing taskset:  ');
taskset.cues = zeros(1, 16);
while(true)
	if(did.right_hand_mi && did.left_hand_mi && did.both_feet_mi && did.rest_mi)
		printf('rlfr\n');
		taskset.cues(1) = cues.right_hand_mi;
		taskset.cues(2) = cues.left_hand_mi;
		taskset.cues(3) = cues.rest_mi;
		taskset.cues(4) = cues.both_feet_mi;
		break;
	end
	if(did.right_hand_mi && did.left_hand_mi && did.both_feet_mi)
		printf('rlbf\n');
		taskset.cues(1) = cues.right_hand_mi;
		taskset.cues(2) = cues.left_hand_mi;
		taskset.cues(3) = cues.both_feet_mi;
		break;
	end
	if(did.right_hand_mi && did.left_hand_mi)
		printf('rhlh\n');
		taskset.cues(1) = cues.right_hand_mi;
		taskset.cues(2) = cues.left_hand_mi;
		break;
	end
	if(did.both_feet_mi && did.left_hand_mi)
		printf('bflh\n');
		taskset.cues(1) = cues.both_feet_mi;
		taskset.cues(2) = cues.left_hand_mi;
		break;
	end
	if(did.both_feet_mi && did.right_hand_mi)
		printf('rhbf\n');
		taskset.cues(1) = cues.right_hand_mi;
		taskset.cues(2) = cues.both_feet_mi;
		break;
	end
	if(did.both_feet_mi && did.both_hands_mi)
		printf('bhbf\n');
		taskset.cues(1) = cues.both_hands_mi;
		taskset.cues(2) = cues.both_feet_mi;
		break;
	end
	break;
end

taskset.bar.right = taskset.cues(1);
taskset.bar.left  = taskset.cues(2);
taskset.bar.up    = taskset.cues(3);
taskset.bar.down  = taskset.cues(4);
taskset.cues = taskset.cues(taskset.cues > 0);
taskset.tot = length(taskset.cues);

g = [2 72 0]/255;
r = [201 49 43]/255;
b = [0 27 91]/255;
y = [184 71 0]/255;
switch(taskset.tot)
	case 4
		taskset.colors = {r b g y};
	case 3
		taskset.colors = {r b g};
	case 2
		taskset.colors = {r b};
end