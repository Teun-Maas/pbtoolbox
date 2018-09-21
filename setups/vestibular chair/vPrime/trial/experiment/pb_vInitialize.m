function cnt = pb_vInitialize(h, initialize)
% PB_VREADYEXP(h,initialize)
%
% PB_VREADYEXP() interacts with GUI during check in/out experiment. 
%
% See also PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if initialize; initialize = 'off'; else; initialize = 'on'; end

   set(h.buttonClose,   'Enable', initialize)                % avoid closing GUI during executing run function     
   set(h.buttonRun,     'Enable', initialize)
   set(h.buttonLoad,    'Enable', initialize)
   
   if strcmp(initialize,'off')
      % Ready feedback plots
      axes(h.signals); cla;   
      axes(h.eTrace); cla; h.eTrace.YLim = [0 300]; h.eTrace.XLim = [0 2.5]; 
      axes(h.hTrace); cla; h.hTrace.YLim = [0 300]; h.hTrace.XLim = [0 2.5];
   else
      disp([newline newline 'Experiment finished!']);
   end
   
   if nargout == 1; cnt = 0; end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

