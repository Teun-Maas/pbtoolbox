function make_suplabel(obj,varargin)
% PB_DRAFT>MAKE_SUPLABEL
%
% OBJ.MAKE_SUPLABEL(varargin) make superlabels handle.
%
% See also PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   %% Initialize
   %  Get axes, positions and data
   
   %  Correct label width for putative legend
   legendBoundary = 1;
   if obj(1).h_ax_legend.bool
      legendBoundary = obj(1).h_ax_legend.handles.Position(1);
   end
   obj(1).labels.pos = [0 0 legendBoundary 0.975];
   
   %  Assess labels
   bool = true; if numel(obj) == 1; bool = false; end
   lab_x = bool; lab_y = bool;
   
   for iObj = 1:numel(obj) 
      if ~strcmp(obj(1).labels.xlab, obj(iObj).labels.xlab); lab_x = false; end
      if ~strcmp(obj(1).labels.ylab, obj(iObj).labels.ylab); lab_y = false; end
   end
   
   %  Set superlabels
   obj(1).labels.supx = lab_x;
   obj(1).labels.supy = lab_y;
   
   %% Build Suplabel
   %  Set Axis, display labels.
   
   h  = axes('Parent',obj(1).parent,'OuterPosition',obj(1).labels.pos,'Visible','off','tag','Labels');
   
   if lab_x; xlabel(obj(1).labels.xlab,'Visible','on'); end
   if lab_y; ylabel(obj(1).labels.ylab,'Visible','on'); end
   if ~isempty(obj(1).title); title(obj(1).title,'Visible','on','FontSize',18); end
   
   %% Checkout
   %  Store and update primary obj data
   
   obj(1).h_ax_labels = h;
   obj(1).h_ax_plot.playground = [h.Position(1)*0.8 h.Position(2) h.OuterPosition(3:4)];
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
