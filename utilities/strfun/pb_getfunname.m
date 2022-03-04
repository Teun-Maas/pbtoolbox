function fn = pb_getfunname(varargin)
% PB_GETFUNNAME()
%
% PB_GETFUNNAME()  ...
%
% See also ...

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl
   
   depth = pb_keyval('depth',varargin,2);

   s     = dbstack;
   fn    = s(depth).name;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

