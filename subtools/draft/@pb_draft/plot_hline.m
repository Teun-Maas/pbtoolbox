function plot_hline(obj,varargin)
% PB_DRAFT>PLOT_DLINE
%
% OBJ.PLOT_DLINE(varargin) will add plot handle for draft function to object.
%
% See also PB_DRAFT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl
   
   p.v         = varargin;
   p.lim       = obj(1).pva.limits.x;
   obj.dplot   = vertcat(obj.dplot,{@(dobj,data)hline(dobj,data,p)});
end

function h = hline(~,data,p)
   %  Plots horizontal line
   
   type     = pb_keyval('type',p.v,'mid');
   point    = pb_keyval('point',p.v);
   style    = pb_keyval('style',p.v,'k--');
   
   if isempty(point)
      switch type
         case 'mid'
            point = (min(data.y)+max(data.y))/2;
         case 'mean'
            point = mean(data.y);
         case 'mode'
            point = mode(data.y);
      end
   end
   h = pb_hline(point,'lim',p.lim,'style',style);
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
