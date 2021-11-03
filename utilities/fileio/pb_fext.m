function [ext,name] = pb_fext(fname)
% PB_FEXT(FNAME)
%
% PB_FEXT(FNAME) splits fnames in name and extension.
%
% See also PB_CHECKEXT
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   index = strfind(fname, '.');

   if isempty(index) 
      ext   = [];
      name  = fname;
   elseif length(index) > 1
      error('Filenames cannot contain more than 1 full stop.')
   else
      name  = fname(1:index-1);
      ext   = fname(index:end);
   end
end


 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

