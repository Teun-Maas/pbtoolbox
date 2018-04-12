function [h,stats] = pb_probit(RT, varargin)
% PB_PROBIT(RT,VARARGIN)
%
% Creates a template function for PBToolbox.
%
% PB_PROBIT(RT,VARARGIN)  ...
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
    
    visibility = pb_keyval('visibility',varargin,'off');
%     disp = pb_keyval('disp',varargin,'false');
    
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
    
    h = plot(q,prob,'o--');
    hold on
    
    set(gca,'XTick',xtick,'XTickLabel',-1./xtick);
    xlim([min(xtick) max(xtick)]);
    set(gca,'YTick',prob,'YTickLabel',p*100);
    ylim([probit(0.1/100) probit(99.9/100)]);
    axis square;
    box off
    
    xlabel('Reaction time (ms)');
    ylabel('Cumulative probability');
    %title('Probit ordinate');

    x = q; y = prob;
    b = regstats(y,x);
    b = regline(b.beta,'k--');
    pb_hline();
    
    stats = b;

    
%     if disp
%         txt = ['Y = ' num2str(beta(2),2)]; %'X + ' num2str(b.beta(1),2) ];
%         text(range(1)-.00625,range(4)+2.7,txt,'HorizontalAlignment','left');
%     end

    set(b,'HandleVisibility',visibility);
        
end

function chi = probitscale(cdf)

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

