function chanDat = pb_createchanDat(channel,cfg)
% PB_NEWTARGET(CHANNEL,CHANDAT)
%
% Choose new X,Y coordinates for 2-stimuli paradigms.
%
% PB_NEWTARGET(CHANNEL,CHANDAT) generates new target coordinates for
% secundary targets, and selects new target based on multiplexers.
%
% See also GENEXP_LOC, GENEXP_DDS

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

    chanDat         = cfg.lookup(ismember(cfg.lookup(:,1),channel),:);
    chanDat(:,7)    = (chanDat(:,2)-1)*4+chanDat(:,3); % individual mplx (not RP2's!)
    
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

