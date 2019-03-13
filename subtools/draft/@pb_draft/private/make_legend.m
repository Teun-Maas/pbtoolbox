function make_legend(obj,varargin)
% PB_DRAFT>MAKE_LEGEND
%
% OBJ.MAKE_LEGEND(varargin) rescale, size and store axes handles..
%
% See also PB_DRAFT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl
   
   %% Initialize
   %  Assert legend and set axis
   
   lgnd     = obj(1).h_ax_legend;
   if ~lgnd.bool; return; end
   
   ncol     = length(unique(obj(1).pva.color));
   entries  = lgnd.features.entries;
   if length(entries) ~= ncol; disp('Error: Number of entries and colors in legend did not match.'); return; end
   
   %  Get parameters
   col   = pb_selectcolor(ncol,obj(1).pva.def);
   move  = 0;
   sz    = 0.04;
   
   %% Build Legend
   %  Set Axis, display entries.
   
   %  Set axis
   h = axes('Parent',obj(1).parent,'Visible','off','Position',lgnd.pos,'tag','Legend'); 
   xlim([0 1]); ylim([0 1]);
   hold on;
   
   %  Fill legend entries 
   for iCol = 1:ncol
      pos      = 0.5 + (ncol*sz/2) - (iCol-1)*sz -sz/2;
      p(iCol)  = plot(0,pos,'Marker','o','Visible','on','Color',col(iCol,:),'MarkerFaceColor',col(iCol,:));
      t(iCol)  = text(0.1,pos,entries{iCol},'Visible','on','FontSize',lgnd.features.fontsize);
      
      %  Assert longest entry
      if move < t(iCol).Extent(3); move = t(iCol).Extent(3); end
   end
   
   %  Align right 
   move           = (.95-move) * 0.10;
   h.Position(1)  = h.Position(1) + move;
   
   %% Checkout
   %  Store and update primary obj data
   
   obj(1).h_ax_legend.handles = h;
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
