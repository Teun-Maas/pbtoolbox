function make_axes(obj,ax,varargin)
% PB_DRAFT>SET_LEGEND
%
% OBJ.SET_LEGEND(varargin) rescale, size and store axes handles..
%
% See also PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   obj(1).h_ax_plot = ax;
   
   % TODO: LINK AXES AND FIND OPTIMAL AXE TICKS
   
   positions = zeros(length(ax),4);
   for iAx = 1:length(ax)
      positions(iAx,:) = ax(iAx).Position(:);
   end
   obj(1).labels.ypos   = min(positions(:,2));
   obj(1).labels.xpos   = min(positions(:,1));
   obj(1).labels.pos    = [min(positions(:,1))/1.33 min(positions(:,2))/1.33 max(positions(:,1)+positions(:,3)) max(positions(:,2)+positions(:,4))];
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
