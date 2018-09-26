function handles = pb_vInitialize(handles, initialize)
% PB_VINITIALIZE(HANDLES, INITIALIZE)
%
% PB_VINITIALIZE(HANDLES, INITIALIZE) interacts with GUI and command window 
% during check in/out of experiment. 
%
% See also PB_VPRIME, PB_VPRIME, PB_VRUNEXP.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if initialize
      buttonPress = 'off';    clc;
      fprintf(['<strong>Experiment has started.</strong>' newline newline]);
   else 
      buttonPress = 'on'; 
      fprintf([newline newline '<strong>Experiment has finished.</strong>' newline newline]);
      
      handles.cfg.recording = num2str(str2double(handles.cfg.recording)+1,'%04d');
      set(handles.editRec,'string',handles.cfg.recording)
   end

   set(handles.buttonClose,   'Enable', buttonPress)                % avoid closing GUI during executing run function     
   set(handles.buttonRun,     'Enable', buttonPress)
   set(handles.buttonLoad,    'Enable', buttonPress)
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

