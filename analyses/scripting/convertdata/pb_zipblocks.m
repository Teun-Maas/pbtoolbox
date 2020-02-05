function fn = pb_zipblocks(cdir,varargin)
% PB_ZIPBLOCKS
%
% PB_ZIPBLOCKS(cdir) converts and bulks all datafiles for each block in the
% vestibular setup together. Input: experimental folder. Output: merged
% converted data.
%
% See also PB_CONVERTDATA

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   if nargin == 0; cdir = pb_getdir('dir','/Users/jjheckman/Documents/Data/PhD/Experiment'); end
   cd(cdir);
   
   listing = dir('block_info_*.mat');
   
   Data     = struct([]);
   for iL = 1:length(listing)
      disp(['>> Unpacking: ' listing(iL).name '...']);
      disp('    >> Converting data...');
      tmp   = pb_convertdata([cd filesep listing(iL).name]);
      disp('    << Data succesfully converted.');
      tmpsz = length(tmp);
      
      %  Zip blocks
      if isempty(Data)
         Data = tmp; 
      else
         Data(end+1:end+tmpsz) = tmp; 
         disp(['    << ' num2str(tmpsz) ' block(s) appended.']);
      end
   end
   
   fn = listing(1).name(1:end-9);
   fn = strrep(fn,'block_info_','converted_data_');
   fn = [fn '.mat'];
   save([cd filesep fn], 'Data');
   disp(['<< Zip complete... (fn: ' fn ')']);
   
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 



%%

