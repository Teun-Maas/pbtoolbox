function pb_setupShow(handles)
% PB_SETUPSHOW
%
% PB_SETUPSHOW(handles) sets up axes for vPrime GUI.
%
% See also PB_VPRIMEGUI, PB_VPRIME, PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   axes(handles.signals); 
   cla; hold on; 
   axis([0 120 -50 50]);
   box off

   axes(handles.hTrace); 
   cla; hold on; 
   axis([0 2.5 0 300]);
   box off

   axes(handles.eTrace); 
   cla; hold on; 
   axis([0 2.5 0 300]);
   box off
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

