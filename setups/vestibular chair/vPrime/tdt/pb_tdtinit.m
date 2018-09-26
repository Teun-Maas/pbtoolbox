function handles = pb_tdtinit(handles)
% PB_TDTINIT()
%
% PB_TDTINIT()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


   if ~ispc; return; end

   %% Active X Control/Objects
   % cfg.HF				= figure('Tag','ActXWin','name','ActiveX Window for TDT','numbertitle','off','menubar','none'); % Figure for ActiveX components
   zBus              = ZBUS(1); % zBus, number of racks
   RZ6_1             = RZ6(1,handles.cfg.RZ6_1circuit); % Real-time acquisition

   Fs                = RZ6_1.GetSFreq;
   handles.cfg.RZ6Fs	= Fs;
   
   for muxIdx = 1:2
      MUX(RZ6_1,muxIdx);
   end

   %% TDT status
   handles.cfg.RZ6_1Status	= RZ6_1.GetStatus;
   handles                 = tdt_monitorMinor(handles);

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

