function rc = pb_runPupil(varargin)
% PB_RUNPUPIL(varargin)
%
% PB_RUNPUPIL(varargin) sets javaclasspath, and initializes remote control pupillabs. 
%
% See also: PUPIL_REMOTE_CONTROL, PB_STARTPUPIL

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
    
    default.j  = [pb_userpath 'subtools/zeromq/jeromq.jar'];
    default.p  = 'pupil-desktop.local'; 
    
    jpath      = pb_keyval('java', varargin, default.j);
    host       = pb_keyval('host', varargin, default.p);
    
    javaclasspath(jpath);
    
    rc         = pupil_remote_control(host); 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

