function pb_niceboxplot(h, varargin)
% PB_NICEBOXPLOT(h, varargin)
%
% PB_NICEBOXPLOT(h, varargin) searches a plot for boxplots and then
% redefines their layout. Note that colors, outliers, and adjacent values
% can be changed.
%
% See also PB_NICEGRAPH, PB_SELECTCOLOR, BOXPLOT
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if nargin == 0; h = gca; end
 
   outliers = pb_keyval('outliers',varargin,0);
   ac = pb_keyval('ac',varargin,0);
   def = pb_keyval('def',varargin,2);
   
   if ~ac; delete(pb_fobj(h,'Tag','Upper Adjacent Value')); delete(pb_fobj(h,'Tag','Lower Adjacent Value')); end
   if ~outliers; delete(pb_fobj(h,'Tag','Outliers')); end
   
   n = length(pb_fobj(h,'Tag','Box'));
   
   lines = pb_fobj(h,'Type','Line');
   
   col = pb_selectcolor(n,def);
   
   linewidth   = 2;
   linestyle    = '-';
   linecomp    = 4+outliers+ac+ac;
   
   for i = 1:n
      for j = i:n:linecomp*2
         lines(j).LineWidth = linewidth;
         lines(j).LineStyle = linestyle;
         lines(j).Color = col(i,:);
      end

   end
   
   bx = pb_fobj(gca,'Tag','Box');
   for k=1:length(bx)
      patch(get(bx(k),'XData'),get(bx(k),'YData'),col(k,:),'FaceAlpha',.3,'EdgeColor',col(k,:),'LineWidth',linewidth);
   end
   figure(gcf);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

