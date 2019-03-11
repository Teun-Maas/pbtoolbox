function make_legend(obj,varargin)
% PB_DRAFT>MAKE_LEGEND
%
% OBJ.MAKE_LEGEND(varargin) rescale, size and store axes handles..
%
% See also PB_DRAFT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl
   
   lgnd = obj(1).h_ax_legend;
   if lgnd.bool
      h = axes('Units','Normal','Position',[.85 .3 .15 .4],'tag','legend','Visible','off');
      hold on;
      
      ncol = length(unique(obj(1).pva.color));
      col = pb_selectcolor(ncol,obj(1).pva.def);
      move = 0;
      for iCol = 1:ncol
         pos = 0.575 - (iCol-1)*.075;
         t(iCol) = text(0.1,pos,lgnd.features.entries{iCol},'Visible','on','FontSize',lgnd.features.fontsize);
         p(iCol) = plot(0,pos,'Marker','o','Visible','on','Color',col(iCol,:),'MarkerFaceColor',col(iCol,:));
         xlim([0 1]);
         ylim([0 1]);
         
         if move<t(iCol).Extent(3); move = t(iCol).Extent(3); end
      end
      move           = (.95-move)*0.15;
      h.Position(1)  = h.Position(1)+move;
   end
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
