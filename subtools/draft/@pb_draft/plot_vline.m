function plot_vline(obj,varargin)
% PB_DRAFT>PLOT_VLINE
%
% OBJ.PLOT_VLINE(varargin) will add plot handle for draft function to object.
%
% See also PB_DRAFT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl
   
   p.v         = varargin;
   p.lim       = obj(1).pva.limits.y;
   obj.dplot   = vertcat(obj.dplot,{@(dobj,data)vline(dobj,data,p)});
end

function h = vline(~,data,p)
   %  Plots vertical line
   
   type     = pb_keyval('type',p.v,'mid');
   point    = pb_keyval('point',p.v);
   style    = pb_keyval('style',p.v,'k--');
   
   if isempty(point)
      switch type
         case 'mid'
            point = (min(data.x)+max(data.x))/2;
         case 'mean'
            point = mean(data.x);
         case 'mode'
            point = mode(data.x);
      end
   end
   h = pb_vline(point,'lim',p.lim,'style',style);
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
