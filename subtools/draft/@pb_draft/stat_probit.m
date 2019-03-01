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
   
   obj.plot_hline;
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
   
   if isempty(y); disp('No entry for y-data found!'); return; end
   gcol  = pb_selectcolor(length(p.ncol),5);
   color = pb_selectcolor(length(p.ncol),data.def);
   color = color(colorindex,:);
   

	%% Rawdata
   %  Plot rawdata

   iRT   = 1/(y);
   x     = -1./sort(y);
   n     = numel(iRT);
   y     = probitscale((1:n)./n);
   %h(1)    = plot(x,y,'Color',gcol(colorindex,:),'Marker','o','MarkerFaceColor',gcol(colorindex,:),'LineStyle','None');

	%% Quantiles & regression

   p        = [1,2,5,10,25,50,75,90 95 98 99]/100;
   xtick    = sort(-1./(150+[0 pb_oct2bw(50,-1:5)]));

   prob     = sqrt(2) * erfinv(2*p - 1);
   q        = -1./quantile(y,p);
   b        = regstats(prob,q);
   
   rl       = regline(b.beta,'k--');
   h     = plot(q,prob,'Color',color,'Marker','o','MarkerFaceColor',color,'LineStyle','None');
   %set(h(1),'Tag','Rawdata');
   set(h,'Tag','Probit model');
   set(rl,'Tag','Graphical aid: regline');

	%% Design
   %  Set Axis for probit
   
   % TODO: --> FIGURE OUT WHY THE FUCK THERE IS NO VISUAL PROBIT MODEL?
% 
%    set(gca,'XTick',xtick,'XTickLabel',-1./xtick);
%    set(gca,'YTick',prob,'YTickLabel',p*100);
%    xlim([min(xtick) max(xtick)]);
%    ylim([probit(0.1/100) probit(99.9/100)]);
%    xlabel('Reaction time (ms)');
%    ylabel('Cumulative probability');
%    axis square;
% 	box off
end

function chi = probitscale(cdf)
   % creates a probitscale

   chi    = sqrt(2) * erfinv(2*cdf - 1);
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

