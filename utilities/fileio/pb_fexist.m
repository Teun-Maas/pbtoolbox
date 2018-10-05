function bool = pb_fexist(fn,varargin)
% PB_FEXIST()
%
% PB_FEXIST()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   searchType  = pb_keyval('type', varargin,'file');
   bool        = exist(fn,searchType) == 2;
   
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

