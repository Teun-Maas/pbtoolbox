function plot_dline(obj,varargin)
% PB_DRAFT>PLOT_DLINE
%
% OBJ.PLOT_DLINE(varargin) will add plot handle for draft function to object.
%
% See also PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   p.v         = varargin;
   obj.dplot   = vertcat(obj.dplot,{@(dobj,data)dline(dobj,data,p)});
end

function h = dline(~,~,p)
   %  Plots diagonal line
   
   style       = pb_keyval('style',p.v,'k--');
   visibility  = pb_keyval('visibility',p.v,'off');
   
   h = pb_dline('style',style,'visibility',visibility);
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
