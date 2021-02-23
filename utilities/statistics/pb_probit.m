function [h,D] = pb_probit(D, varargin)
% PB_PROBIT(RT,VARARGIN)
%
% Creates a probit plot.
%
% PB_PROBIT(RT,VARARGIN) plots RT data and transforms axes to the classic
% probit display, i.e. cum. prob. vs promptness. Note, multiple RTs have to
% be passed on as structs: D(n).RT, else a simple RT var (double) suffices.
%
% See also PLOT, PB_NICEGRAPH, REGSTATS
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   %% Initalize
   
	visibility  = pb_keyval('HandelVisibility',varargin,'off');
	ho          = pb_keyval('ho',varargin,ishold);
	fig         = pb_keyval('fig',varargin, gcf);
	ax          = pb_keyval('ax',varargin, gca);
   col         = pb_keyval('color',varargin,[0 0 0]);
	gcol        = pb_keyval('gcolor',varargin,[.66 .66 .66]);
   linestyle   = pb_keyval('linestyle',varargin,'none');
   
   pb_selectfig(fig);
   pb_selectaxis(ax);
   hold on;

	%% Rawdata
   
   iRT   = 1./D;
   x     = -1./sort(D);
   n     = numel(iRT);
   y     = probitscale((1:n)./n);
   h(1)  = plot(x,y,'Marker','o','Color',gcol,'MarkerFaceColor',gcol,'Linestyle','None');
   set(h(1),'Tag','Fixed');

	%% Quantiles & regression

   p        = [1,5,10,25,50,75,90, 95, 99]/100;
   xtick    = sort(-1./(120+[0 pb_oct2bw(50,-1:3)]));

   prob	= probitscale(p);
   q		= -1./quantile(D,p);
   b     = regstats(prob,q);

   rl          = regline(b.beta,'k--');
   rl.Color    = gcol;
   
   h(2)        = plot(q,prob,'color',col,'Marker','o','MarkerFaceColor',col,'LineStyle',linestyle);

   set(h,'Tag','Fixed');
   set(rl,'Tag','graphical aid: regline');
   set(rl,'HandleVisibility',visibility);   
   
	%% Design

   set(gca,'XTick',xtick,'XTickLabel',-1./xtick);
   set(gca,'YTick',prob,'YTickLabel',p*100);
   xlim([min(xtick) max(xtick)]);
   ylim([probit(0.1/100) probit(99.9/100)]);
   xlabel('Reaction time (ms)');
   ylabel('Cumulative probability');
   axis square;
   box off

   f = pb_fobj(gca,'Tag','horline');
   if isempty(f)
      f = pb_hline(0,'visibility','off');
      set(f,'Tag','horline');
   end

   if ~ho; hold off; end
end

function chi = probitscale(cdf)
   % Creates a probitscale
   
   myerf       = 2*cdf - 1;
   myerfinv    = sqrt(2)*erfinv(myerf);
   chi         = myerfinv;    
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

