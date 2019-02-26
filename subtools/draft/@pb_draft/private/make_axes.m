function make_axes(obj,ax,varargin)
% PB_DRAFT>MAKE_AXES
%
% OBJ.SET_LEGEND(varargin) rescale, size and store axes handles..
%
% See also PB_DRAFT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl
   
   linkaxes(ax,'xy');
   
   positions = zeros(length(ax),4);
   
   for iAx = 1:length(ax)
      axis(ax(iAx));
      xt    = xticks;
      yt    = yticks;
      setAx = ax(iAx);
      
      xlim(ax(iAx),[xt(1) xt(end)]);
      ylim(ax(iAx),[yt(1) yt(end)]);
      positions(iAx,:) = ax(iAx).Position(:);
      
      if obj(1).grid.bool
         f = obj(1).grid.features;
         setAx.Box           = f.Box;
         setAx.TickDir       = f.TickDir;
         setAx.TickLength    = f.TickLength;
         setAx.XMinorTick    = f.XMinorTick;
         setAx.YMinorTick    = f.YMinorTick;
         setAx.YGrid         = f.YGrid;
         setAx.XGrid         = f.XGrid;
         setAx.YColor        = f.YColor;
         setAx.XColor        = f.XColor;
         setAx.FontSize      = f.FontSize;
         setAx.YDir          = f.YDir;
         setAx.LineWidth     = f.LineWidth;
      end
   end
   
   obj(1).labels.ypos   = min(positions(:,2));
   obj(1).labels.xpos   = min(positions(:,1));
   obj(1).labels.pos    = [min(positions(:,1))/1.33 min(positions(:,2))/1.33 max(positions(:,1)+positions(:,3)) max(positions(:,2)+positions(:,4))];
   obj(1).h_ax_plot = ax;
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
