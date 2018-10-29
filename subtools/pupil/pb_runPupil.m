function rc = pb_runPupil(varargin)
% PB_RUNPUPIL(varargin)
%
% PB_RUNPUPIL(varargin) sets javaclasspath, and initializes remote control pupillabs. 
%
% See also: PUPIL_REMOTE_CONTROL, PB_STARTPUPIL

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
    
    default.j  = [pb_userpath 'subtools' filesep 'zeromq' filesep 'jeromq.jar'];
    default.p  = 'dcn-pl01.science.ru.nl'; 
    
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

