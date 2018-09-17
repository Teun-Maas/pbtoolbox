function nblocks = pb_spheretrial2complete(dname)
% SPHERETRIAL2COMPLETE
%
% Combine the SPHERE trial files to one file
%
% See also SPHEREMAT2HOOPCSV, SPHEREMAT2HOOPDAT


%% Initialization
if nargin<1
	% 	fname = [];
	%dir;
	d = what;
	dname = d.path;
end


cd(dname);
d = dir('*.sphere');

%% find unique blocks
f		= char(d.name);
f		= f(:,1:end-12);
ublocks = unique(f,'rows');

%% Load date per block
nblocks = size(ublocks,1);
for blockIdx = 1:nblocks
	fname	= ublocks(blockIdx,:);
	d		= dir([fname '*.sphere']);
	D		= [];
	T		= [];
	for fIdx = 1:numel(d)
		%disp(['Loading ' d(fIdx).name]);
		load(d(fIdx).name,'-mat');
		D	= [D data]; %#ok<AGROW>
		
		if exist('dur','var')
		trialsingle.duration = dur;
		end
		T	= [T trialsingle]; %#ok<AGROW>
	end
	data	= D;
	trial	= T; %#ok<NASGU>

	fname = fcheckext(fname,'sphere');
	fname = fullfile(dname,fname);
	save(fname,'data','trial','cfg');
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

