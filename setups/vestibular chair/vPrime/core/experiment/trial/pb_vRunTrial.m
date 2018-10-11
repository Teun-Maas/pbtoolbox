function pb_vRunTrial(cfg,stim)
% PB_VRUNTRIAL(HANDLES)
%
% PB_VRUNTRIAL(HANDLES)  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% Run zBus
   cfg.zBus.zBusTrigA(0, 0, 2); % reset, clock start, (0,0,2): trigger entire rack, with a pulse structure, and 2 ms delay(2 ms = minimum).

   %% Trigger event 1
   % cfg.zBus.zBusTrigB(0, 0, 2); % start event 1, trial onset
   cfg.zBus.zBusTrigB(0, 0, 2); % start event 1/trial onset; trigger zBus 4 = RA16;

   %% Button Press
   disp('Waiting for RZ6 button press/sound/led/acquisition');

   t = tic;
%    while ~cfg.RZ6_1.GetTagVal('Wait')
%    % 	disp('waiting')
%       % do nothing
%    end % sound is played after this loop exits.
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

