function [theta, phi] = pb_newtarget(channel,chanDat,varargin)

% PB_NEWTARGET(CHAN,CHANDAT)
%
% Choses new target location in multiple target paradigm.
%
% PB_NEWTARGET(CHAN,CHANDAT) selects new target based on RP2 status. 
% --> FUTURE FUNCTION: INCORPORATE X,Y CORRELATION BETWEEN OLD AND NEW
% TARGET
%
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
    
    direction = pb_keyval('direction',varargin,false);
    
    sel1    = chanDat(:,1) == channel;
    rp2     = chanDat(sel1,2); X = chanDat(sel1,5); Y = chanDat(sel1,6);
    
    sel2    = chanDat(:,1) ~= 10 & chanDat(:,2) ~= rp2;
    chns    = chanDat(sel2,:);
    msize   = length(chns(:,1));
    newChan = chns(randperm(msize, 1),1);
    sel3    = chanDat(:,1) == newChan;
    
    
    theta   = round(chanDat(sel3,5));
    phi     = round(chanDat(sel3,6));
    
    dmatch  = atan2d(Y,X) == atan2d(phi,theta);
    cnt     = 0;
    
    while direction && dmatch && cnt<3
        newChan = chns(randperm(msize, 1),1);
        sel3    = chanDat(:,1) == newChan;


        theta   = round(chanDat(sel3,5));
        phi     = round(chanDat(sel3,6));   
        cnt     = cnt+1;
    end
    
end




% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
