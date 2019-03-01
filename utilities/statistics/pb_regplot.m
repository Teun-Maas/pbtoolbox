function [h,b,r] = pb_regplot(X,Y,varargin)
% PB_REGPLOT
%
% plots data, and linear regression.
%
% PA_REGPLOT(X,Y,varargin) plots X vs Y, and performs linear regression on X and Y.
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
   %% Initialization

   v           = varargin;
   marker      = pb_keyval('marker',v,'o');
   data        = pb_keyval('data',v,true);
   text        = pb_keyval('text',v,false);
   color       = pb_keyval('color',v,'k');
   linestyle   = pb_keyval('linestyle',v,'--');
   linewidth   = pb_keyval('linewidth',v,2);
   
   X     = X(:)';
   Y     = Y(:)';
   
   hs    = ishold(gca);
   hold on;
   
   %% Regression
   b     = regstats(Y,X,'linear','beta');
   b     = b.beta;
   
   gain                        = b(2);
   bias                        = b(1);
   r                           = corrcoef(X,Y); r = r(2);

   %% Graphics
   h = gobjects(0);
   if data; h(1) = plot(X, Y, ['k' marker]); end
   axxes = axis;
   h(end+1) = plot(axxes([1 2]),gain*axxes([1 2])+bias,'Color',color,'LineStyle',linestyle,'LineWidth',linewidth);
   if ~hs; hold off; end
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

