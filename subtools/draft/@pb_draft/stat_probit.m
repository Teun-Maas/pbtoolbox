function stat_probit(obj,varargin)
% PB_DRAFT>PB_PROBIT
%
% Creates a probit plot.
%
% OBJ.STAT_PROBIT(varargin) plots RT data and transforms axes to the classic
% probit display, i.e. cum. prob. vs promptness.
%
% See also PB_DRAFT, DRAFT, PB_PROBIT
 
% PBToolbox (2019): JJH: j.heckman@donders.ru.nl
   
   v              = varargin;
   p.ncol         = pb_keyval('ncol',v,unique(obj.pva.color));
   p.visibility   = pb_keyval('visibility',v,'off');
   
   for iCol = 1:length(p.ncol)
      obj.dplot   = vertcat(obj.dplot,{@(dobj,data)probit_stat(dobj,data,p,p.ncol(iCol))});
   end
   obj.results.rawdata_handle = {};
   obj.pva.setAxes            = false;
end

function h = probit_stat(~,data,p,colorindex)
   %% Initialize
   %  Read and select data.
   
	sel   = data.color == colorindex;
   y     = data.y(sel);
   
   if isempty(y); return; end
   gcol  = pb_selectcolor(3,5);
   color = pb_selectcolor(length(p.ncol),data.def);
   color = color(colorindex,:);
   
   h = pb_probit(y,'color',color,'gcolor',gcol(1,:));
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

