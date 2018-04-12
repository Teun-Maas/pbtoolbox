function [fpath] = pb_getfile(varargin)
% PB_GETFILE()
%
% Creates a template function for PBToolbox.
%
% PB_GETFILE()  ...
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


    cdir = pb_keyval('dir',varargin,userpath);
    ext = pb_keyval('ext',varargin,'*.*');
    cd(cdir);

    [fname, path] = uigetfile(ext); 
    fpath = [path fname];

    if fpath(1) == 0; fpath = []; return; end
    
end


 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

