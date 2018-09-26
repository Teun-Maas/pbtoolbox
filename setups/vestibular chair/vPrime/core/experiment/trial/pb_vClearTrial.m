function pb_vClearTrial(handles)
% PB_VCLEARTRIAL(HANDLES)
%
% PB_VCLEARTRIAL(HANDLES) empties previous trial: data, stimuli, GUI, and
% updates the command window.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   tn = handles.cfg.trialnumber;
   bn = handles.cfg.blocknumber;
      
   disp([newline '<strong>New Trial started...</strong> '...
         newline ' Trial: ' num2str(tn(2)) ' (B' num2str(bn) 'T' num2str(tn(1)) ')']);

end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

