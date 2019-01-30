function draft(obj)
% PB_DRAFT>DRAFT
%
% OBJ.DRAFT will draw a figure from a pb_draft-object.
%
% See also PB_DRAFT, SET_LABELS, SET_TITLE, SET_GRID, PRINT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


   % 	Select/make figure
   if isempty(obj(1).parent)
      for iObj = 1:numel(obj)
      	obj(iObj).parent = gcf;
      end
   end
   
   %  Set figure
   set(obj(1).parent,'color','w');
   t = sgtitle(obj(1).parent,obj(1).title);
   set(t,'FontSize',20);
   
   ax       = gobjects(0);
   dsz      = size(obj);
   
   %  Draft each subplot
   for iObj = 1:numel(obj)
      
      iAx = pb_invidx([dsz(1), dsz(2)],iObj);
      
      %  Make axes 
      ax(iAx) = subplot(dsz(1),dsz(2),iObj); % pb_invidx([dsz(1), dsz(2)],iAx)
      if obj(iAx).pva.subtitle; title(obj(iAx).pva.subtitle); end
      axis(obj(iAx).pva.axis);
      hold on;
      
      %  Plot data
      
      
      %  Set proper labels
      xlabel(obj(iAx).labels.xlab);
      ylabel(obj(iAx).labels.ylab);
      
      %  Make scientific notations on the axes.
      ax(iAx).YAxis.Exponent = length(num2str(max(abs(round(ax(iAx).YLim)))))-1;
      ax(iAx).XAxis.Exponent = length(num2str(max(abs(round(ax(iAx).XLim)))))-1;
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

