function handles = pb_tdtinit(handles)
% PB_TDTINIT(HANDLES)
%
% PB_TDTINIT(HANDLES) sets tdt initials prior to experimentation.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VSETUPTRIAL

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if ~ispc; return; end

   %% Active X Control/Objects
   zBus              = ZBUS(1);                                            % zBus, number of racks
   RZ6_1             = RZ6(1,handles.cfg.RZ6_1circuit);                    % Real-time acquisition

   Fs                = RZ6_1.GetSFreq;
   handles.cfg.RZ6Fs	= Fs;
   
   for muxIdx = 1:4  % muxID
      pb_MUX(RZ6_1,muxIdx);
   end

   %% TDT status
   handles.cfg.RZ6_1Status	= RZ6_1.GetStatus;

   %% Configuration
   handles.cfg.RZ6_1       = RZ6_1;
   handles.cfg.zBus        = zBus;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

