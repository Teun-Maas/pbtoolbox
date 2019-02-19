function plot_rawdata(obj,varargin)
% PB_DRAFT>PLOT_RAWDATA
%
% OBJ.PLOT_RAWDATA(varargin) will add plot handle for draft function to object.
%
% See also PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   v           = varargin;
   p.type      = pb_keyval('type',v,'line');
   p.alpha     = pb_keyval('alpha',v,1);     %% crashes if you change the alpha to below 1?
   p.marker    = pb_keyval('marker',v,'o');
   p.markersz  = pb_keyval('markersz',v,3);
   p.ls        = pb_keyval('linestyle',v,'none');
   p.fcol      = pb_keyval('facecolor',v,'fill');
   p.col       = pb_keyval('color',v,'k');
   
   obj.dplot   = vertcat(obj.dplot,{@(dobj,data)rawdata(dobj,data,p)});
   obj.results.rawdata_handle = {};
end

function h = rawdata(~,data,p)
   %  Plots rawdata
   
   switch p.type
      case 'dot'
         sz    = p.sz;
         h     = scatter(data.x,data.y,ceil(p.markersz/2.5),data.color,'filled','MarkerFaceAlpha',p.alpha); %% crashes if you change the alpha to below 1?
      case 'line'
         if strcmp(p.fcol,'fill'); switchpar = data.color; else; switchpar = 'none'; end
         h = plot(data.x(data.ind), ...
                  data.y(data.ind), ...
                  'Color', data.color, ...
                  'Marker', p.marker, ...
                  'LineStyle',p.ls, ...
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


