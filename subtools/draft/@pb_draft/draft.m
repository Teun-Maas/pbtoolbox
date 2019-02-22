function draft(obj)
% PB_DRAFT>DRAFT
%
% OBJ.DRAFT will draw a figure from a pb_draft-object.
%
% See also PB_DRAFT, SET_LABELS, SET_TITLE, SET_GRID, PRINT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% Create figure
   
   % 	Select parent/make figure
   if isempty(obj(1).parent)
      for iObj = 1:numel(obj)
      	obj(iObj).parent = gcf;
      end
   end
   
   %  Set figure settings
   set(obj(1).parent,'color','w');
   t = sgtitle(obj(1).parent,obj(1).title);
   set(t,'FontSize',20);
   
   ax       = gobjects(0);
   dsz      = size(obj);
   
   %% Super labels
   %  Check if labels are the same, and prep super labels
   
   lab_x = true; lab_y = true;
   for iObj = 1:numel(obj) 
      if ~strcmp(obj(1).labels.xlab, obj(iObj).labels.xlab); lab_x = false; end
      if ~strcmp(obj(1).labels.ylab, obj(iObj).labels.ylab); lab_y = false; end
   end
   obj(1).labels.supx = lab_x;
   obj(1).labels.supy = lab_y;
      
   %% Create (sub)plots
   %  Draft each subplot
   
   %  Select compare axis.
   objsz    = numel(obj);
   cmpsz    = 1;
   tmpV     = [];
   
   if isfield(obj(1).pva,'axcomp'); tmpV = obj(1).pva.axcomp; end
   if ~isempty(tmpV) && objsz == 1; cmpsz = length(unique(tmpV.feature)); end
   
   for iCmp = 1:cmpsz
      
      %  Make  Compare Axes 
      %  // NOTE THAT THIS IS VERY INEFFICIENT: DO 1) MAKE AXCMP DEFAULT 1
      r  = 1;
      c  = 1;
      ax(iCmp)  = subplot(r,c,iCmp);
      
      for iObj = 1:objsz
         %  Make Axes 
         iAx      = pb_invidx([dsz(1), dsz(2)],iObj);
         ax(iAx)  = subplot(dsz(1),dsz(2),iObj);

         if obj(iAx).pva.subtitle; title(obj(iAx).pva.subtitle); end
         axis(obj(iAx).pva.axis);
         hold on;

         % Set colors
         nCol = 1;
         if ~obj(iObj).pva.continious 
            nCol = length(unique(obj(iObj).pva.color));
         end

         %  Plot all graphs
         for iDP = 1:length(obj(iObj).dplot)
            d 	= obj(iAx).pva;
            obj(iObj).dplot{iDP}(obj,d);
         end

         %  Set labels
         if ~obj(1).labels.supx; xlabel(obj(iAx).labels.xlab); end
         if ~obj(1).labels.supy; ylabel(obj(iAx).labels.ylab); end

         %  Make scientific notations on the axes.
         ax(iAx).YAxis.Exponent = length(num2str(max(abs(round(ax(iAx).YLim)))))-1;
         ax(iAx).XAxis.Exponent = length(num2str(max(abs(round(ax(iAx).XLim)))))-1;
      end
   end
   
   %% Adjust axis handles
   %  Set super labels
   
   %  TO DO:
   %  1. Optionalize subplots to have squared/linked/fixed axis
   %  2. Scale and move axis to make graph nice, pleasing and non-overlapping
   make_axes(obj,ax);
   make_suplabel(obj);
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 




   %       %  FIX COLOR REPEAT ONLY FOR COLOR SPLITTING DATA
   %       colors   = pb_selectcolor(nCol,obj(iAx).pva.def);
   %       uD       = unique(obj(iAx).pva.color);
   %       for iCol = 1:nCol
   %          d        = obj(iAx).pva;
   %          d.ind    = d.color == uD(iCol);
   %          d.color  = colors(iCol,:);
   %       end

