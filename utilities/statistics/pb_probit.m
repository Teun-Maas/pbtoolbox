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
   
	visibility  = pb_keyval('visibility',varargin,'off');
	ho          = pb_keyval('ho',varargin,ishold);
	fig         = pb_keyval('fig',varargin, gcf);
	ax          = pb_keyval('ax',varargin, gca);
   
   pb_selectfig(fig);
   pb_selectaxis(ax);
   hold on;

   len = length(D); 
	rd = gobjects(len); rl = gobjects(len); h = gobjects(len);

	%% Rawdata
   
	for i = 1:len
      iRT   = 1/D(i).rt;
      x     = -1./sort(D(i).rt);
      n     = numel(iRT);
      y     = probitscale((1:n)./n);
      rd(i) = plot(x,y,'Marker','o','Color',[.66 .66 .66],'MarkerFaceColor',[.66 .66 .66]);
   end

   %set(rd,'Tag','rawdata');

	%% Quantiles & regression

   p       = [1,2,5,10,25,50,75,90 95 98 99]/100;
   xtick	= sort(-1./(150+[0 pb_oct2bw(50,-1:5)]));

   for j = 1:len
      prob	= probit(p);
      q		= -1./quantile(D(j).rt,p);
      b    = regstats(prob,q);

      D(j).stats = b;
      rl(j) = regline(b.beta,'k--');
      h(j) = plot(q,prob,'o');
   end

   set(h,'Tag','probit model');
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

   pb_hline();

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

