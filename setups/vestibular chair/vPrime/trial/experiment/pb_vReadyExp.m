function pb_vInitialize(h, initialize)
% PB_VREADYEXP()
%
% PB_VREADYEXP()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   set(h.buttonClose,   'Enable', ~initialize)                % avoid closing GUI during executing run function     
   set(h.buttonRun,     'Enable', ~initialize)
   set(h.buttonLoad,    'Enable', ~initialize)
   
   if initialize
      % Ready feedback plots
      axes(h.signals); cla;   
      axes(h.eTrace); cla; h.eTrace.YLim = [0 300]; h.eTrace.XLim = [0 2.5]; 
      axes(h.hTrace); cla; h.hTrace.YLim = [0 300]; h.hTrace.XLim = [0 2.5];
   else
      disp([newline newline 'Experiment finished!']);
   end
 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

