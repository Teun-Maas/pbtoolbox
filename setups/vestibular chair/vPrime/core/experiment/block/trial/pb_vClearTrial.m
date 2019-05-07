function cfg = pb_vClearTrial(stim, cfg)
% PB_VCLEARTRIAL
%
% PB_VCLEARTRIAL(stim, cfg) empties previous trial: data, stimuli, GUI, and
% updates the command window.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


   %% Remove ledhandle if it exists
   
   nstim = numel(stim);
   for iStm = 1:nstim
      if isfield(stim(iStm),'ledhandle')
         if ~isempty(stim(iStm).ledhandle)
            stim(iStm).ledhandle.delete; 	% delete(leds)/switch off light;
         end
      end
   end
   
   %% Turn off sounds
   
   for muxIdx = 1:4
      MUX(cfg.RZ6_1,muxIdx,0)
   end
   
   %% Initiate trial

   tn = cfg.trialnumber;
   bn = cfg.blocknumber;
      
   disp([newline '<strong>New Trial started...</strong> '...
         newline ' Trial: ' num2str(tn(2)) ' (B' num2str(bn) 'T' num2str(tn(1)) ')']);
      
   if ispc
      cfg.zBus.zBusTrigA(0, 0, 2);                                         % reset, clock start, (0,0,2): trigger entire rack, with a pulse structure, and 2 ms delay(2 ms = minimum).
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

