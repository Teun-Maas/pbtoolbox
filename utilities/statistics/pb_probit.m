function [h,D] = pb_probit(D, varargin)
% PB_PROBIT(RT,VARARGIN)
%
% Creates a probit plot.
%
% PB_PROBIT(RT,VARARGIN) plots RT data and transforms axes to the classic
% probit display, i.e. cum. prob. vs promptness. Note, RTs have to be passed on as structs: D(n).RT
%
% See also PLOT, PB_NICEGRAPH, REGSTATS
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
    
    visibility = pb_keyval('visibility',varargin,'off');
    ho         = pb_keyval('ho',varargin,ishold);
    
    hold on;

    %% rawdata
    for i = 1:length(D)
       iRT = 1/D(i).rt;
       x = -1./sort(D(i).rt);
       n = numel(iRT);
       y = probitscale((1:n)./n);
       rd(i) = scatter(x,y);
       set(rd,'Tag','rawdata');
    end

    
    %% quantiles & regression
    p		= [1,2,5,10,25,50,75,90 95 98 99]/100;
    xtick	= sort(-1./(150+[0 pb_oct2bw(50,-1:5)]));
    
    for j=1:length(D)
       prob	= probit(p);
       q		= -1./quantile(D(j).rt,p);
       
       b = regstats(prob,q);
       D(j).stats = b;
       
       rl(j) = regline(b.beta,'k--');
       h(j) = plot(q,prob,'o');
    end
   
    set(gca,'XTick',xtick,'XTickLabel',-1./xtick);
    xlim([min(xtick) max(xtick)]);
    set(gca,'YTick',prob,'YTickLabel',p*100);
    ylim([probit(0.1/100) probit(99.9/100)]);
    axis square;
    box off
    
    xlabel('Reaction time (ms)');
    ylabel('Cumulative probability');

    pb_hline();
    
    if ~ho; hold off; end
    
    set(h,'Tag','probit model');
    set(rl,'Tag','graphical aid: regline');
    set(rl,'HandleVisibility',visibility);     
end

function chi = probitscale(cdf)
    % creates a probitscale
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

