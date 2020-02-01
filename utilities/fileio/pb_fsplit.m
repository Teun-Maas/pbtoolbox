function [file,path] = pb_fsplit(fn)
% PB_FSPLIT
%
% PB_FSPLIT(fn)  splits file and path.
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl
   
   if strcmp(fn(end),filesep); error(['Filename cannot end with a filesep (' filesep ').']); end
   
   seps  = strfind(fn,filesep);
   file  = fn(seps(end)+1:end);
   path  = fn(1:seps(end));
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

