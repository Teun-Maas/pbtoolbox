function draft(obj)
% PB_DRAFT>DRAFT
%
% OBJ.DRAFT will draw a figure from a draft object.
%
% See also PB_DRAFT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   %% Initialize Draft
   %  Make figure, select parents, and set layouts
   
   % 	Select parent/make figure
   if isempty(obj(1).parent)
      for iObj = 1:numel(obj)
      	obj(iObj).parent = gcf;
      end
   end
   
   %  Set figure settings
   set(obj(1).parent,'Color',[1 1 1]);
   set(obj(1).parent,'renderer','painters');
   
   %% Draft Layout
   %  Assert and prepare legend, and suplabels
   
   obj.make_legend;
   obj.make_suplabel; 
   obj.make_axes;          % CURRENTLY WORKING ON MAKE PLOTS
   
   %% DONE TILL HERE!!! REST NEEDS FIXING!
   
   %%  Set Compare Axis
   %  Check and set comparing axis
   
%    ax       = gobjects(0);
%    objsz    = size(obj);
%    
%    nCmp     = length(unique(obj(1).pva.axcomp.feature));
%    if min(objsz) > 1; nCmp = 1; end
%    
%    cmpsz          = [1 1];
%    [~,cmpInd]     = max(cmpsz);
%    cmpsz(cmpInd)  = nCmp; 
%    cmpsz          = fliplr(cmpsz);
%    
%    obj(1).h_ax_plot.sz = cmpsz .* size(obj);
   
   %% Create Plots
   %  Draft each subplot
   
   for iObj = 1:numel(obj)
      % Repeat for comparing axis
      for iCmp = 1:nCmp
         cObj    = (iObj-1)*nCmp + iCmp;
         
         %  Make Axes 
         Ax       = pb_invidx(objsz.*cmpsz,cObj);                          % reverse get axes index
         Ax2Obj   = pb_invidx(objsz,iObj);                                 % reverse get object index
         %ax(Ax)   = subplot(objsz(1)*cmpsz(1),objsz(2)*cmpsz(2),cObj);     % make axis

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
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 