function [fname, path] = pb_getfile(varargin)
% PB_GETFILE(VARARGIN)
%
% PB_GETFILE(VARARGIN) returns selected file from gui. Default input
% for directory is userpath.
%
% See also PB_GETDIR
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


    cdir    = pb_keyval('dir',varargin,userpath);
    ext     = pb_keyval('ext',varargin,'*.*');
    title 	= pb_keyval('title',varargin,'Open file...'); % titles have been removed from matlab ui's in OS X - El capitain
    
    cd(cdir);

    [fname, path] = uigetfile(ext,title); 
    fpath = [path fname];

    if fpath(1) == 0; fpath = []; return; end
    
end


 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

