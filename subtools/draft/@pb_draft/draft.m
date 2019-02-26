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
   objsz    = size(obj);
   
   %% Super labels
   %  Check if labels are the same, and prep super labels
   
   lab_x = true; lab_y = true;
   for iObj = 1:numel(obj) 
      if ~strcmp(obj(1).labels.xlab, obj(iObj).labels.xlab); lab_x = false; end
      if ~strcmp(obj(1).labels.ylab, obj(iObj).labels.ylab); lab_y = false; end
   end
   obj(1).labels.supx = lab_x;
   obj(1).labels.supy = lab_y;
   
   
   %%  Set Compare axis
   cmp      = length(unique(obj(1).pva.axcomp.feature));
   cmpsz    = [1 1];
   nObj     = numel(obj)*cmp;
   
   if min(objsz)>1 
      cmp = 1; 
   else
      if objsz(1)<objsz(2)
         % horizontal direction
         cmpsz(1) = cmp;
      else
         % vertical direction
         cmpsz(2) = cmp;
      end
   end
   
      %% Create (sub)plots
   %  Draft each subplot
   
   for iObj = 1:numel(obj)
      % Repeat for comparing axis
      for iCmp = 1:cmp
         cObj    = (iObj-1)*cmp + iCmp;
         
         %  Make Axes 
         Ax       = pb_invidx([objsz(1)*cmpsz(1), objsz(2)*cmpsz(2)],cObj);   % reverse get axes index
         Ax2Obj   = pb_invidx([objsz(1), objsz(2)],iObj);                     % reverse get object index
         ax(Ax)   = subplot(objsz(1)*cmpsz(1),objsz(2)*cmpsz(2),cObj);        % make axis

         if obj(iObj).pva.subtitle; title(obj(Ax2Obj).pva.subtitle); end         
         axis(obj(Ax2Obj).pva.axis);
         hold on;
         
         % Select data
         uFeat    = unique(obj(1).pva.axcomp.feature);
         sel      = obj(1).pva.axcomp.feature == uFeat(iCmp);
         D        = obj(Ax2Obj).pva;
         D.x      = D.x(sel);
         D.y      = D.y(sel);
         D.color  = D.color(sel);
         
         % Set colors
         nCol = 1;
         if ~obj(iObj).pva.continious 
            nCol = length(unique(obj(iObj).pva.color));
         end

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
   
   %% Adjust axis handles
   %  Set super labels
   
   %  TO DO:
   %  1. Optionalize subplots to have squared/linked/fixed axis
   %  2. Scale and move axis to make graph nice, pleasing and non-overlapping
   obj.make_axes(ax);
   obj.make_suplabel;
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 