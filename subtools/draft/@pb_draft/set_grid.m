function set_grid(obj,varargin)
% PB_DRAFT>SET_GRID
%
% SET_GRID(obj,title,varargin) will set grid parameters.
%
% See also PB_DRAFT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   v  = varargin;
   f.Box           = pb_keyval('Box',v,'off');
   f.TickDir       = pb_keyval('Tickdir',v,'in');
   f.TickLength    = pb_keyval('Ticklength',v,[.02 .02]);
   f.XMinorTick    = pb_keyval('XMinorTick',v,'on');
   f.YMinorTick    = pb_keyval('YMinorTick',v,'on');
   f.YGrid         = pb_keyval('YGrid',v,'on');
   f.XGrid         = pb_keyval('XGrid',v,'on');
   f.YColor        = pb_keyval('YColor',v,[.3 .3 .3]);
   f.XColor        = pb_keyval('XColor',v,[.3 .3 .3]);
   f.FontSize      = pb_keyval('FontSize',v,10);
   f.YDir          = pb_keyval('YDir',v,'normal');
   f.LineWidth     = pb_keyval('LineWidth',v,0.1);

   obj(1).grid.bool     = true;
   obj(1).grid.features = f;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

