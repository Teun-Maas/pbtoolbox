function fullpath = pb_searchfile(path,fname)
% PB_SEARCHFILE(PATH, FNAME)
%
% Searches for fname within a path directory.
%
% PB_SEARCHFILE(PATH, FNAME)  searches for fname within a path, and returns
% the fullpath [path fname] of the first fname it found within path. Note:
% make sure fname extension is included!
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
   dirinfo     = dir(path);
   dirinfo(~[dirinfo.isdir]) = [];  %remove non-directories
   subdirinfo  = cell(length(dirinfo));
   fullpath    = [];
   
   for K = 1:length(dirinfo)
      thisdir = dirinfo(K).name;
      subdirinfo{K} = dir(fullfile(thisdir, fname));
   end
   
   a = find(~isempty(subdirinfo),1);
   if ~isempty(subdirinfo{a}); fullpath = [subdirinfo{a}.folder filesep subdirinfo{a}.name]; else; disp([newline '   ' fname ' could not be found!']); end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

