function make_axes(obj,varargin)
% PB_DRAFT>MAKE_AXES
%
% OBJ.MAKE_AXES(varargin) make, scale, size and store axes handles.
%
% See also PB_DRAFT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl
   
   %% Initialize
   %  Obtain axes data
   
   %  Assess playground
   playground  = obj(1).h_ax_plot.playground;
   objsz       = size(obj);
   
   %  Assess axcompare
   nCmp        = length(unique(obj(1).pva.axcomp.feature));
   if min(objsz) > 1; nCmp = 1; end
   
   cmpsz      	= [1 1];
   [~,cInd]   	= max(cmpsz);
   cmpsz(cInd) = nCmp; 
   cmpsz    	= fliplr(cmpsz);
   graphsz     = cmpsz .* objsz;
   ngraph      = prod(graphsz);
   
   %% Build Playground
   %  Set graphing axes
   
   h     = gobjects(ngraph,1);
   pos   = axis_pos(obj,graphsz,playground);
   
%    h           = pb_fobj(gcf,'Tag','legend');
%    scale       = [h.Position(1) 1]; 
%    sz          = obj(1).h_ax_plot.sz;
%    szfl        = fliplr(sz);
%    opObj       = ax(1).OuterPosition(3:4)*scale(1);
    
   for iAx = 1:ngraph
      
      %% DONE TILL HERE!!! REST NEEDS FIXING!
      %  ASSIGN AXES TO POSITION RELATIVE TO PLAYGROUND AND INDEX
      
      %pos = [0.1+(iAx/20) 0.3 0.3 0.3];
      
      cAx   = pb_invidx(graphsz,iAx);                                           % align axes and objects
      h(cAx) = axes('Parent',obj(1).parent,'Position',pos(iAx,:));
      axis square
      
      % Set Grids
      if obj(1).grid.bool
         f = obj(1).grid.features;
         h(cAx).Box           = f.Box;
         h(cAx).TickDir       = f.TickDir;
         h(cAx).TickLength    = f.TickLength;
         h(cAx).XMinorTick    = f.XMinorTick;
         h(cAx).YMinorTick    = f.YMinorTick;
         h(cAx).YGrid         = f.YGrid;
         h(cAx).XGrid         = f.XGrid;
         h(cAx).YColor        = f.YColor;
         h(cAx).XColor        = f.XColor;
         h(cAx).FontSize      = f.FontSize;
         h(cAx).YDir          = f.YDir;
         h(cAx).LineWidth     = f.LineWidth;
      end
      
      %  Set labels
%       if ~obj(1).labels.supx; xlabel(obj(Ax2Obj).labels.xlab); end
%       if ~obj(1).labels.supy; ylabel(obj(Ax2Obj).labels.ylab); end

      %% SHOULD I GO FOR THIS? MAYBE THIS COMPLICATES STUFF
      %  Make scientific notations on the axes.
      h(cAx).YAxis.Exponent = length(num2str(max(abs(round(h(cAx).YLim)))))-1;
      h(cAx).XAxis.Exponent = length(num2str(max(abs(round(h(cAx).XLim)))))-1;  
   end 
   
   diff = abs(obj(1).h_ax_labels.Position(2) - h(end).OuterPosition(2));
   
   %% Checkout
   %  Store and update primary obj data
   obj(1).h_ax_labels.Position(2)	= obj(1).h_ax_labels.Position(2)+diff;
   obj(1).h_ax_labels.Position(4)	= obj(1).h_ax_labels.Position(4)-(2*diff);
   obj(1).h_ax_plot.handles         = h;
   obj(1).h_ax_plot.sz              = graphsz;
end

function pos = axis_pos(obj,sz,area)
   %  Defines the positions of all graphic axes in a given graphic area

   %  Get sizes
   rep = prod(sz);
   pos = zeros(rep,4);
   asz = obj(1).parent.Position;
   
   %  Find smallest ratio
   ra    = (area(3)*asz(3)) / (area(4)*asz(4));
   rs    = sz(2)/sz(1);

   width = area(4)/sz(1);                       % get y length
   if ra/rs < 1; width = area(3)/sz(2); end     % change to x length
   width = width*.9;
   
   for iAx = 1:rep
      
      %  Get idx position
      [c,r] = pb_mod(iAx,sz(2)); 
      if c == 0; c = sz(2); end
      N  = [r+1,c];
      
      %  Get normalized position
      x  = area(1)/2 + (N(2)-1)*width;
      y  = (sz(1)*width*1.1)/2 + 0.5 - N(1)*width;
      
      pos(iAx,:) = [x y width width];
   end
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
