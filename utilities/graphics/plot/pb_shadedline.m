function pb_shadedline(D,varargin)
% PB_SHADEDLINE(D, varargin)
%
% PB_SHADEDLINE(D, varargin) allows you to plot shaded lines. Both line and
% shade types can be inidicated in keyvals.
%
% See also PB_KEYVAL, PLOT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% INITIALIZE
   %  initialize (default) parameters, and set figure handles
   
   %  Set vars
   fig   = pb_keyval('fig',varargin,gcf);
   ax    = pb_keyval('axis',varargin,gca);
   col   = pb_keyval('col',varargin,'r');
   def   = pb_keyval('def',varargin,2);
   alpha = pb_keyval('alpha',varargin,.3);
   line  = pb_keyval('line',varargin,'mean');
   shade = pb_keyval('shade',varargin,'std');
   
   %  Set figure handles
   figure(fig); 
   axes(ax);
   hs = ~ishold;
   hold on; 
   
   %  Define Colors
   Dsz = size(D);
   if isempty(col)
      col = pb_selectcolor(Dsz(2),'def',def);     % YOU CAN ONLY PLOT 1 LINE AT THE TIME (= 1 COLOR)
   end
   
   %% PROCESS DATA
   %  Define line and shadetype, and prepare data
   
   %  Set linetype
   switch line
      case 'mean'
         LineDat = nanmean(D)';
      case 'fit'
         LineDat = [];
      otherwise
         LineDat = nanmean(D)';           % case 'mean'
   end
   
   %  Set shadetype
   switch shade
      case 'std'
         ShadeDat = nanstd(D);
      case 'sem'
         ShadeDat = nanstd(D)/sqrt(Dsz(1));
      case 'range'
         ShadeDat = max(D);
      otherwise
         ShadeDat = nanstd(D);            % case 'std'
   end   
   
   F = 1 : Dsz(2);

   if ne(size(F,1),1)
       F=F';
   end
   fill([F fliplr(F)],[LineDat+ShadeDat fliplr(LineDat-ShadeDat)],col);
   

   plot(F,LineDat,col,'linewidth',1.5);   % change color or linewidth to adjust mean line
   if hs; hold off; end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

