function pb_niceboxplot(h, varargin)
% PB_NICEBOXPLOT(h, varargin)
%
% PB_NICEBOXPLOT(h, varargin) searches a plot for boxplots and then
% redefines their layout. Note that colors, outliers, and adjacent values
% can be changed.
%
% See also PB_NICEGRAPH, PB_SELECTCOLOR, BOXPLOT
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% Set initial variables
   if nargin == 0; h = gcf; end

   outliers    = pb_keyval('outliers',varargin,0);
   ac          = pb_keyval('ac',varargin,0);
   def         = pb_keyval('def',varargin,1);
   colmatch    = pb_keyval('colmatch',varargin,0);
   col         = pb_keyval('col',varargin);
   alpha       = pb_keyval('alpha',varargin,.3);
   linewidth   = pb_keyval('linewidth',varargin,1.5);
   linestyle   = pb_keyval('linestyle',varargin,'-');

   %% Body
   axx = pb_fobj(gcf,'Type','Axes');
   for iAxes=1:length(axx)
      ax = axx(iAxes);

      % Remove BS
      if ~ac; delete(pb_fobj(ax,'Tag','Upper Adjacent Value')); delete(pb_fobj(ax,'Tag','Lower Adjacent Value')); end
      if ~outliers; delete(pb_fobj(ax,'Tag','Outliers')); end

      nBP = length(pb_fobj(ax,'Tag','Box'));
      lines = pb_fobj(ax,'Type','Line');

      % Create color pattern
      if isempty(col); col = pb_selectcolor(nBP,def); end
      if colmatch || size(col,1) ~= nBP; for iN=2:nBP; col(iN,:) = col(1,:); end; end

      linecomp    = 4+outliers+ac+ac;

      for i=1:nBP
         for j = i:nBP:linecomp*nBP
            lines(j).LineWidth = linewidth;
            lines(j).LineStyle = linestyle;
            lines(j).Color = col(i,:);
         end
      end
      bx = pb_fobj(ax,'Tag','Box');
      for k=1:length(bx)
         patch(axx(iAxes),get(bx(k),'XData'),get(bx(k),'YData'),col(k,:),'FaceAlpha',alpha,'EdgeColor',col(k,:),'LineWidth',linewidth);
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

