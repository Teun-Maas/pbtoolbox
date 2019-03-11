function make_axes(obj,ax,varargin)
% PB_DRAFT>MAKE_AXES
%
% OBJ.MAKE_AXES(varargin) rescale, size and store axes handles..
%
% See also PB_DRAFT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl
   
   linkaxes(ax,'xy');
   positions   = zeros(length(ax),4);
   
   %  Get legend data
   h           = pb_fobj(gcf,'Tag','legend');
   scale       = [h.Position(1) 1]; 
   sz          = obj(1).h_ax_plot.sz;
   szfl        = fliplr(sz);
   opObj       = ax(1).OuterPosition(3:4)*scale(1);
    
   nAx         = length(ax);
   for iAx = 1:nAx
      cAx   = pb_invidx(sz,iAx);                                           % align axes and objects
      ax(cAx);
      
      %  Scale for legend
      if obj(1).h_ax_legend.bool 
         [xN,yN]     = pb_mod(iAx,sz(2)); if xN == 0; xN = sz(2); end
         N           = [xN,yN+1];
         spacing     = [];
         for iDir = 1:2
            width          = ax(cAx).OuterPosition(2+iDir);
            spacing(iDir)  = (scale(iDir)-(width*szfl(iDir)))/(szfl(iDir)+1);
            if iDir == 1; ax(cAx).OuterPosition(1) = (N(1)-1)*width + N(1)*spacing(iDir); end
            if iDir == 2
               if spacing(2)>spacing(1)*1.5
                   spacing(2) = spacing(1)*1.5;
               end
               margin = (1-(sz(1)*width + (sz(1)-1)*spacing(2)))/2*1.1;
               ax(cAx).OuterPosition(2) = 1-margin-(N(2)*width) - (N(2)-1)*spacing(iDir);
            end
         end
         ax(cAx).OuterPosition(3:4) = opObj;
      end

      % Set Limits
      if obj(1).pva.setAxes
         xlim(ax(cAx),obj(1).pva.limits.x);
         ylim(ax(cAx),obj(1).pva.limits.y);
      end

      % Set Grids
      setAx = ax(cAx);
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
      positions(cAx,:) = ax(cAx).Position(:);
   end
   
   % Set Label Positions
   % TODO: THIS MUST BE DONE WAY BETTER!!
   % NOTE THAT AXES ARE NOT SAME SIZE? (SEE MOST RIGHT FIGURES), ALSO
   % POSITION IS NOT ALIGNED!
   
   obj(1).labels.ypos   = min(positions(:,2));
   obj(1).labels.xpos   = min(positions(:,1));
   obj(1).labels.pos    = [min(positions(:,1))/1.33 min(positions(:,2))/1.33 max(positions(:,1)+positions(:,3)) max(positions(:,2)+positions(:,4))];
   obj(1).h_ax_plot     = ax;
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
