function [h,stats] = pb_probit(RT, varargin)
% PB_PROBIT(RT,VARARGIN)
%
% Creates a probit plot.
%
% PB_PROBIT(RT,VARARGIN) plots RT data and transforms axes to the classic
% probit display, i.e. cum. prob. vs RTs. Note, function can be used in
% combination 
%
% See also PLOT, PB_NICEGRAPH, REGSTATS
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
    
    visibility = pb_keyval('visibility',varargin,'off');
    ho         = pb_keyval('ho',varargin,ishold);
    
    iRT = 1/RT;
    x = -1./sort(RT);
    n = numel(iRT);
    y = probitscale((1:n)./n);
    scatter(x,y);
    
    hold on;
    
    % quantiles
    p		= [1,2,5,10,25,50,75,90 95 98 99]/100;
    prob	= probit(p);
    q		= -1./quantile(RT,p);
    xtick	= sort(-1./(150+[0 pb_oct2bw(50,-1:5)]));
    
    h = plot(q,prob,'o');
    
    if ~ho; hold off; end
    
    set(gca,'XTick',xtick,'XTickLabel',-1./xtick);
    xlim([min(xtick) max(xtick)]);
    set(gca,'YTick',prob,'YTickLabel',p*100);
    ylim([probit(0.1/100) probit(99.9/100)]);
    axis square;
    box off
    
    xlabel('Reaction time (ms)');
    ylabel('Cumulative probability');


    x = q; y = prob;
    b = regstats(y,x);
    b = regline(b.beta,'k--');
    pb_hline();
    
    stats = b;

    set(b,'HandleVisibility',visibility);     
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

