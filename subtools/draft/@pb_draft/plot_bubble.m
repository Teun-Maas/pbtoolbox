function plot_bubble(obj,varargin)
% PB_DRAFT>PLOT_RAWDATA
%
% OBJ.PLOT_RAWDATA(varargin) will add plot handle for draft function to object.
%
% See also PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   v           = varargin;
   
   p.XW     = pb_keyval('Xwidth',v);
   p.YW     = pb_keyval('Ywidth',v);
   p.BS     = pb_keyval('binsize',v);
   p.def    = pb_keyval('def',v,5);
   p.marker = pb_keyval('marker',v,'o');
   
   obj.dplot   = vertcat(obj.dplot,{@(dobj,data)bubble_plot(dobj,data,p)});
   obj.results.bubbleplot_handle = {};
end

function h = bubble_plot(~,data,p)
   %%  Bubbleplot
   
   %  Select binsizes 
   if isempty(p.XW); [~,~,p.XW,~] = pb_binsize(data.x); p.XW = p.XW*3; end
   if isempty(p.YW); [~,~,p.YW,~] = pb_binsize(data.y); p.YW = p.YW*3; end
   if ~isempty(p.BS); p.XW = p.BS; p.YW = p.BS;  end
   
   %  Hist
   X        = round(data.x/p.XW) * p.XW;
   Y        = round(data.y/p.YW) * p.YW;
   uX       = unique(X);
   uY       = unique(Y);
   [UX,UY]  = meshgrid(uX,uY);
   
   x		= uY;

   TOT		= NaN(size(UX));
   for ii	= 1:length(uX)
      sel		= X == uX(ii);
      r			= Y(sel);
      N			= hist(r,x);
      if isscalar(x)
      N			= histogram(r,[x-Xwidth x+Xwidth]);
      end
      TOT(:,ii)	= N;
   end

   % Normalize
   TOT         = log10(TOT+1);
   maxima(1)   = nanmax(nanmax(TOT));
   maxima(2)   = nanmin(nanmin(TOT));
   TOT         = (TOT-maxima(2))./(maxima(1)-maxima(2));

   % Plot
   M     = TOT(:);
   x     = UX(:);
   y     = UY(:);

   sel   = M>0;
   M     = M(sel);
   x     = x(sel);
   y     = y(sel);

   SZ          = ceil(100*M);
   [~,~,idx]	= unique(M);
   col			= statcolor(max(idx),[],[],[],'def',p.def);
   C           = col(idx,:);
   h           = scatter(x,y,SZ,C,'filled');
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
