function pb_vRunTrial(zbus, trialdur)
% PB_VRUNTRIAL(HANDLES)
%
% PB_VRUNTRIAL(HANDLES)  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% Run zBus
   zbus.zBusTrigA(0, 0, 2); % reset, clock start, (0,0,2): trigger entire rack, with a pulse structure, and 2 ms delay(2 ms = minimum).

   %% Trigger event 1
   zbus.zBusTrigB(0, 0, 2); % start event 1/trial onset; trigger zBus 4 = RA16;

   t = tic;
   while toc(t) < trialdur
      pause(0.05);
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
