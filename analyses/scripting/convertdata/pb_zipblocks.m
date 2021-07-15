function fn = pb_zipblocks(cdir,varargin)
% PB_ZIPBLOCKS
%
% PB_ZIPBLOCKS(cdir) converts and bulks all datafiles for each block in the
% vestibular setup together. Input: experimental folder. Output: merged
% converted data.
%
% See also PB_CONVERTDATA

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   if nargin == 0; cdir = pb_getdir('cdir','/Users/jjheckman/Documents/Data/PhD/Experiment'); end
   cd(cdir);
   
   listing = dir('block_info_*.mat');
   
   D     = struct([]);
   for iL = 1:length(listing)
      disp(['>> Unpacking: ' listing(iL).name '...']);
      disp('    >> Converting data...');
      tmp   = pb_convertdata([cd filesep listing(iL).name]);
      disp('    << Data succesfully converted.');
      tmpsz = length(tmp);
      
      %  Zip blocks
      if isempty(D)
         D = tmp; 
      else
         D(end+1:end+tmpsz) = tmp; 
         disp(['    << ' num2str(tmpsz) ' block(s) appended.']);
      end
   end
   
   % Tag condition
   if contains(cd, 'dynamic'); chair = 'D'; else; chair = 'S'; end       % (THIS REALLY REQUIRES PROPER DATA MANAGEMENT FOLDER STRUCTURE)
   if contains(cd, 'free'); head = 'U'; else; head = 'R'; end
   
   % get filename
   fn = listing(1).name(1:end-9);
   fn = strrep(fn,'block_info_','converted_data_');
   fn = [fn '_' chair head '.mat'];
   
   save([fullfile(cd,'..') filesep fn], 'D');
   disp(['<< Zip complete... (fn: ' fn ')']);
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

