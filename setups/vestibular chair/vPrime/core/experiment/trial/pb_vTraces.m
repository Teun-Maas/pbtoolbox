function pb_vTraces(handles)
% PB_VTRACES
%
% PB_VTRACES(handles) updates the trace velocity plots of eye and head in
% GUI.
%
% See also PB_VRUNEXP, PB_VPRIMEGUI.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% PLOT TRACES
   %  head trace
   axes(handles.hTrace); hold on;
   ws = 20; b  = (1/ws)*ones(1,ws); a  = 1;

   x  = 0:.05:2.5; 
   y  = randi(300,1,length(x)) .* tukeywin(length(x), 2)';
   y  = filter(b,a,y) .* tukeywin(length(x),1)';
   plot(x,y);

   %  eye trace
   axes(handles.eTrace); hold on;    
   ws = 20; b  = (1/ws)*ones(1,ws); a  = 1;

   x  = 0:.05:2.5; 
   y  = randi(300,1,length(x)) .* tukeywin(length(x), 2)';
   y  = filter(b,a,y) .* tukeywin(length(x),1)';
   plot(x,y);

   %%  HIGHLIGHT CURRENT
   te = pb_fobj(handles.eTrace,'Type','Line'); 
   th = pb_fobj(handles.hTrace,'Type','Line'); 
   col = pb_selectcolor(10,5);
   
   for iT = 1:length(th)
      switch iT 
         case length(th)
            th(iT).Color = col(10,:);
            te(iT).Color = col(10,:);
         otherwise 
            th(iT).Color = col(1,:);
            te(iT).Color = col(1,:);
      end
   end
   pause(1); % Hold for a sec!
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

