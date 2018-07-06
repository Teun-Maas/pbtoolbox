function pb_niceboxplot(h, varargin)
% PB_NICEBOXPLOT(h, varargin)
%
% PB_NICEBOXPLOT(h, varargin) searches a plot for boxplots and then
% redefines their layout. Note that colors, outliers, and adjacent values
% can be changed.
%
% See also PB_NICEGRAPH, PB_SELECTCOLOR, BOXPLOT
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if nargin == 0; h = gcf; end
   
   outliers = pb_keyval('outliers',varargin,0);
   ac = pb_keyval('ac',varargin,0);
   def = pb_keyval('def',varargin,1);
   
   axx = pb_fobj(gcf,'Type','Axes');
   for iAxes=1:length(axx)
      ax = axx(iAxes);
      
      if ~ac; delete(pb_fobj(ax,'Tag','Upper Adjacent Value')); delete(pb_fobj(ax,'Tag','Lower Adjacent Value')); end
      if ~outliers; delete(pb_fobj(ax,'Tag','Outliers')); end

      n = length(pb_fobj(ax,'Tag','Box'));
      lines = pb_fobj(ax,'Type','Line');
      col = pb_selectcolor(n,def);

      
      linewidth   = 2;
      linestyle   = '-';
      linecomp    = 4+outliers+ac+ac;

      gca
      
      for i=1:n
         for j = i:n:linecomp*n
            lines(j).LineWidth = linewidth;
            lines(j).LineStyle = linestyle;
            lines(j).Color = col(i,:);
         end
      end
      bx = pb_fobj(ax,'Tag','Box');
      for k=1:length(bx)
         patch(axx(iAxes),get(bx(k),'XData'),get(bx(k),'YData'),col(k,:),'FaceAlpha',.3,'EdgeColor',col(k,:),'LineWidth',linewidth);
      end

   end
   figure(gcf);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

