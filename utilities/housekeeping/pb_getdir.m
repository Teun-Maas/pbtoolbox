function path = pb_getdir(varargin)
% PB_GETDIR
%
% PB_GETDIR(varargin) returns selected directory from gui. Default input
% for directory is userpath
%
% See also PB_GETFILE
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cdir    = pb_keyval('cdir',varargin,userpath);
   title 	= pb_keyval('title',varargin,'Open folder...'); % titles have been removed from matlab ui's in OS X - El capitain

   [path] = uigetdir(cdir,title); 

   if path(1) == 0; path = []; return; end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

