function set_legend(obj,varargin)
% PB_DRAFT>SET_LEGEND
%
% OBJ.SET_LEGEND(varargin) will add plot handle for draft function to object.
%
% See also PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   v  = varargin;
   f.marker          = pb_keyval('Marker',v,'o');
   f.entries         = pb_keyval('Entries',v,[]);
   f.fontsize        = pb_keyval('Fontsize',v,9);
   f.fontname        = pb_keyval('Fontname',v,'Helvetica');
   
   obj(1).h_ax_legend.bool       = true;
   obj(1).h_ax_legend.handles    = [];
   obj(1).h_ax_legend.features   = f;
   obj(1).h_ax_legend.pos        = [.85 .1 .15 .8];
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
