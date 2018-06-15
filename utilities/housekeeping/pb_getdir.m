function path = pb_getdir(varargin)
% PB_GETDIR(VARARGIN)
%
% PB_GETDIR(VARARGIN) returns selected directory from gui. Default input
% for directory is userpath
%
% See also PB_GETFILE
 
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

