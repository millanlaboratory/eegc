% 2009-12-08  Michele Tavella <michele.tavella@epfl.ch>
% I'm so fucking awesome with u guys...
function session = eegc3_smr_loadlog(filename)

printf('[eegc3_smr_loadlog] Loading: %s\n', filename);
fid = fopen(filename, 'r');
entries = {};
while 1
	line = fgetl(fid);
	if(ischar(line) == false)
		break;
	end
	entries{end+1} = ...
		textscan(line, '%s%s%s%s%s%s%s%s%s%s%s', 'Delimiter', ' ');
end
fclose(fid); 

printf('[eegc3_smr_loadlog] Allocating stuctures:\n');
all = {};
for i = 1:length(entries)
	all{i}.file = cell2mat(entries{i}{1});
	printf('  %-35.35s ', all{i}.file);
	for j = 2:11
		if(isempty(entries{i}{j}) == true)
			if(j == 2)
				printf('N/A');
			end
			break;
		end
		cache.buffer = cell2mat(entries{i}{j});
		cache.fields = mt_strsplit('=', cache.buffer);
		cache.name = cache.fields{1};
		cache.value = cache.fields{2};
		cache.expression = ['all{i}.' cache.name ' = ''' cache.value ''';'];
		eval(cache.expression);
		printf('%s ', cache.name);
	end
	printf('\n');
end

printf('[eegc3_smr_loadlog] Detecting online/offline:\n');
online = {};
offline = {};
for i = 1:length(all)
	printf('  %-35.35s ', all{i}.file);
	try
		all{i}.classifier;
	catch
		offline{end+1} = all{i};
		printf('offline\n');
		continue;
	end
	online{end+1} = all{i};
	printf('online\n');
end

session = {};
[session.name, session.path] = mtpath_basename(filename);
session.name = strrep(session.name, '.log', '');
session.logfile = filename;
session.all     = all;
session.online  = online;
session.offline = offline;
