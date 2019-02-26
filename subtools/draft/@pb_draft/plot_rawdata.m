function plot_rawdata(obj,varargin)
% PB_DRAFT>PLOT_RAWDATA
%
% OBJ.PLOT_RAWDATA(varargin) will add plot handle for draft function to object.
%
% See also PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   v           = varargin;
   p.type      = pb_keyval('type',v,'dot');
   p.alpha     = pb_keyval('alpha',v,1);     %% crashes if you change the alpha to below 1?
   p.marker    = pb_keyval('marker',v,'o');
   p.markersz  = pb_keyval('markersz',v,3);
   p.linestyle = pb_keyval('linestyle',v,'-');
   p.linewidth = pb_keyval('linestyle',v,2);
   p.fcol      = pb_keyval('facecolor',v,'fill');
   p.col       = pb_keyval('color',v,'k');
   p.ncol      = pb_keyval('ncol',v,unique(obj.pva.color));

   for iCol = 1:length(p.ncol)
      obj.dplot   = vertcat(obj.dplot,{@(dobj,data)rawdata(dobj,data,p,p.ncol(iCol))});
   end
   obj.results.rawdata_handle = {};
end

function h = rawdata(~,data,p,colorindex)
   %  Plots rawdata
   
   %% MAKE SELECTION FOR COLOR!
   
   sel   = data.color == colorindex;
   x     = data.x(sel);
   y     = data.y(sel);
   
   color = pb_selectcolor(length(p.ncol),data.def);
   
   switch p.type
      case 'line'
         h = plot(x, ...
                  y, ...
                  'Color', data.color, ...
                  'Marker', p.marker, ...
                  'LineStyle',p.linestyle, ...
                  'LineWidth', p.linewidth);
      case 'dot'
         if strcmp(p.fcol,'fill'); switchpar = color(colorindex,:); else; switchpar = 'none'; end
         h = plot(x, ...
                  y, ...
                  'Color', color(colorindex,:), ...
                  'Marker', p.marker, ...
                  'LineStyle','none', ...
                  'MarkerFaceColor',switchpar, ...
                  'MarkerSize', p.markersz);
      otherwise 
   end
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


