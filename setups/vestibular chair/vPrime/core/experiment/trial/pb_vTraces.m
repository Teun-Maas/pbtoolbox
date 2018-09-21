function pb_vTraces(h)
% PB_VTRACES()
%
% PB_VTRACES()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% PLOT TRACES
   %  head trace
   axes(h.hTrace); hold on;
   ws = 20; b  = (1/ws)*ones(1,ws); a  = 1;

   x  = 0:.05:2.5; 
   y  = randi(300,1,length(x)) .* tukeywin(length(x), 2)';
   y  = filter(b,a,y) .* tukeywin(length(x),1)';
   plot(x,y);

   %  eye trace
   axes(h.eTrace); hold on;    
   ws = 20; b  = (1/ws)*ones(1,ws); a  = 1;

   x  = 0:.05:2.5; 
   y  = randi(300,1,length(x)) .* tukeywin(length(x), 2)';
   y  = filter(b,a,y) .* tukeywin(length(x),1)';
   plot(x,y);

   %%  HIGHLIGHT CURRENT
   te = pb_fobj(h.eTrace,'Type','Line'); 
   th = pb_fobj(h.hTrace,'Type','Line'); 
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
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

