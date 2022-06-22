function [h,b,r] = pb_regplot(X,Y,varargin)
% PB_REGPLOT
%
% plots data, and linear regression.
%
% PB_REGPLOT(X,Y,varargin) plots X vs Y, and performs linear regression on X and Y.
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
   %% Initialization

   v           = varargin;
   marker      = pb_keyval('marker',v,'o');
   data        = pb_keyval('data',v,true);
   textOut     = pb_keyval('text',v,false);
   color       = pb_keyval('color',v,'k');
   linestyle   = pb_keyval('linestyle',v,'-');
   linewidth   = pb_keyval('linewidth',v,3);
   tag         = pb_keyval('tag',varargin,'Fixed');
   alpha       = pb_keyval('alpha',varargin,1);
   msize       = pb_keyval('size',varargin,10);
   
   X     = X(:)';
   Y     = Y(:)';
   
   hs    = ishold(gca);
   hold on;
   
   %% Regression
   b     = regstats(Y,X,'linear','beta');
   b     = b.beta;
   
   gain   	= b(2);
   bias    	= b(1);
   r       	= corrcoef(X,Y); r = b(2);
   b        = bias;

   %% Graphics
   h = gobjects(0);
   if data
      h(1) = plot(X, Y, marker); 
      h(1).Tag                   = 'Fixed';
      h(1).MarkerEdgeColor       = color;

      
   end
   axxes = axis;
   h(end+1) = plot(axxes([1 2]),gain*axxes([1 2])+bias,'Color',color,'LineStyle',linestyle,'LineWidth',linewidth,'Tag',tag);
   mov = max(axxes)/10;
   if textOut; text(mov,-mov,['r = ' num2str(gain)],'FontSize',18); end
   if ~hs; hold off; end
   uistack(h(1),'top')
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

