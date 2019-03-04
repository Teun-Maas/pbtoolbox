function draft(obj)
% PB_DRAFT>DRAFT
%
% OBJ.DRAFT will draw a figure from a pb_draft-object.
%
% See also PB_DRAFT, SET_LABELS, SET_TITLE, SET_GRID, PRINT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% Initialize Draft
   %  Make figure, select parents, and set layouts
   
   % 	Select parent/make figure
   if isempty(obj(1).parent)
      for iObj = 1:numel(obj)
      	obj(iObj).parent = gcf;
      end
   end
   
   %  Set figure settings
   set(obj(1).parent,'color','w');
   t = sgtitle(obj(1).parent,obj(1).title);
   set(t,'FontSize',18);
   
   ax       = gobjects(0);
   objsz    = size(obj);
   
   %% Super labels
   %  Check and prepare superlabels
   
   %  Check labels
   bool = true; if numel(obj) == 1; bool = false; end
   lab_x = bool; lab_y = bool;
   for iObj = 1:numel(obj) 
      if ~strcmp(obj(1).labels.xlab, obj(iObj).labels.xlab); lab_x = false; end
      if ~strcmp(obj(1).labels.ylab, obj(iObj).labels.ylab); lab_y = false; end
   end
   
   %  Set superlabels
   obj(1).labels.supx = lab_x;
   obj(1).labels.supy = lab_y;
   
   
   %%  Set Compare Axis
   %  Check and set comparing axis
   
   nCmp     = length(unique(obj(1).pva.axcomp.feature));
   if min(objsz) > 1; nCmp = 1; end
   
   cmpsz          = [1 1];
   [~,cmpInd]     = max(cmpsz);
   cmpsz(cmpInd)  = nCmp; 
   cmpsz          = fliplr(cmpsz);
   
   obj(1).h_ax_plot.sz = cmpsz .* size(obj);
   
   %% Create Plots
   %  Draft each subplot
   
   for iObj = 1:numel(obj)
      % Repeat for comparing axis
      for iCmp = 1:nCmp
         cObj    = (iObj-1)*nCmp + iCmp;
         
         %  Make Axes 
         Ax       = pb_invidx(objsz.*cmpsz,cObj);   % reverse get axes index
         Ax2Obj   = pb_invidx(objsz,iObj);                     % reverse get object index
         ax(Ax)   = subplot(objsz(1)*cmpsz(1),objsz(2)*cmpsz(2),cObj);        % make axis

         if obj(iObj).pva.subtitle; title(obj(Ax2Obj).pva.subtitle); end         
         axis(obj(Ax2Obj).pva.axis);
         hold on;
         
         %  Select data
         features = unique(obj(1).pva.axcomp.feature);
         sel      = obj(1).pva.axcomp.feature == features(iCmp);
         
         D        = obj(Ax2Obj).pva;
         D.x      = D.x(sel);
         D.y      = D.y(sel);
         D.color  = D.color(sel);
         

         %  Plot all graphs
         for iDP = 1:length(obj(iObj).dplot)
            obj(iObj).dplot{iDP}(obj,D);
         end

         %  Set labels
         if ~obj(1).labels.supx; xlabel(obj(Ax2Obj).labels.xlab); end
         if ~obj(1).labels.supy; ylabel(obj(Ax2Obj).labels.ylab); end

         %  Make scientific notations on the axes.
         ax(Ax).YAxis.Exponent = length(num2str(max(abs(round(ax(Ax).YLim)))))-1;
         ax(Ax).XAxis.Exponent = length(num2str(max(abs(round(ax(Ax).XLim)))))-1;
      end
   end
   
   %% Adjust Axis Handles
   %  Set super labels
   
   %  TO DO:
   %  1. Scale and move axis to make graph nice, pleasing and non-overlapping

 
   obj.make_axes(ax);
   obj.make_legend;
   obj.make_suplabel;
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 