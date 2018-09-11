function bool = pb_fexist(fn)
% PB_FEXIST()
%
% PB_FEXIST()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   bool = exist(fn, 'file') == 2;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

