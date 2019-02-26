function plot_dline(obj,varargin)
% PB_DRAFT>PLOT_DLINE
%
% OBJ.PLOT_DLINE(varargin) will add plot handle for draft function to object.
%
% See also PB_DRAFT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl
   
   p.v         = varargin;
   p.lim       = [obj(1).pva.limits.x obj(1).pva.limits.y];
   obj.dplot   = vertcat(obj.dplot,{@(dobj,data)dline(dobj,data,p)});
end

function h = dline(~,~,p)
   %  Plots diagonal line
   
   style       = pb_keyval('style',p.v,'k--');
   visibility  = pb_keyval('visibility',p.v,'off');
   
   h = pb_dline('style',style,'lim',p.lim,'visibility',visibility);
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
