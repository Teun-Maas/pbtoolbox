function path = pb_getdir(varargin)
% PB_GETDIR()
%
% Creates a template function for PBToolbox.
%
% PB_GETDIR()  ...
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


    cdir = pb_keyval('dir',varargin,userpath);

    [path] = uigetdir(cdir); 

    if path(1) == 0; path = []; return; end

end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

