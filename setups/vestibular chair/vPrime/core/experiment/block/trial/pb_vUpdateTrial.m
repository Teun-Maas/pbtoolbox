function handles = pb_vUpdateTrial(handles)
% PB_VUPDATETRIAL
%
% PB_VUPDATETRIAL(handles) will update the vPrime GUI during trials.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   cfg   = handles.cfg;
   fig   = handles.figure1.Name;
   tn    = cfg.trialnumber;
   
   fig   = ['vPrime - ' num2str(tn(2)) '/' num2str(cfg.Trials) ' Trials']; % counting title
   str   = num2str(tn(1),'%03d');                                          % blocktrial
   
   set(handles.Tn,'string',str);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
