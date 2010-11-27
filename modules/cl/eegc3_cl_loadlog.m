% 2009-12-08  Michele Tavella <michele.tavella@epfl.ch>
%
% Example: 
%    logfile = '~/Research/cnbi/mi/20101118_a2/a2_20101118.log';
%    session = eegc3_cl_loadlog(logfile);
function session = eegc3_cl_loadlog(filename)

% Recsession.runs.all & harvest
session = eegc3_cl_newsession();
[session.base, session.path] = mtpath_basename(filename);
session.base= strrep(session.base, '.log', '');
[session.name, session.root] = mtpath_basename(session.path);

cache = mt_strsplit('_', session.name);
session.daytime = cache{1};
session.subject = cache{2};


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
cache = {};
for i = 1:length(entries)
	session.runs.all{i}.file = cell2mat(entries{i}{1});
	printf('  %-35.35s ', session.runs.all{i}.file);
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
		cache.expression = ['session.runs.all{i}.' cache.name ' = ''' cache.value ''';'];
		eval(cache.expression);
		printf('%s ', cache.name);
	end
	printf('\n');
end
clear cache;

printf('[eegc3_smr_loadlog] Detecting online/offline:\n');
for i = 1:length(session.runs.all)
	printf('  %-35.35s ', session.runs.all{i}.file);
	try
		session.runs.all{i}.file =[session.path '/' session.runs.all{i}.file];
		session.runs.all{i}.classifier =[session.path '/' session.runs.all{i}.classifier];
	catch
		session.runs.offline{end+1} = session.runs.all{i};
		printf('offline\n');
		continue;
	end
	session.runs.online{end+1} = session.runs.all{i};
	printf('online ');
	try
		session.runs.all{i}.frames;
		session.trace.eegcversion = 2;
		session.runs.all{i}.classifier = [session.runs.all{i}.classifier '.3'];
		printf(' [eegc v2]');
	catch
		session.trace.eegcversion = 3;
		printf(' [eegc v3]');
	end
	printf('%s\n', ' ');
end
