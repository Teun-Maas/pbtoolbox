function handles = pb_vInitialize(handles, initialize)
% PB_VREADYEXP(h,initialize)
%
% PB_VREADYEXP() interacts with GUI during check in/out experiment. 
%
% See also PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if initialize; initialize = 'off'; else; initialize = 'on'; end

   set(handles.buttonClose,   'Enable', initialize)                % avoid closing GUI during executing run function     
   set(handles.buttonRun,     'Enable', initialize)
   set(handles.buttonLoad,    'Enable', initialize)
   
   if strcmp(initialize,'off')
      % test
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

