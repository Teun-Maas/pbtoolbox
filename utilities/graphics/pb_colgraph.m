function pb_colgraph(varargin)
% PB_COLGRAPH(VARARGIN)
%
% Allows you to choose your colors for plotting per axis.
%
% PB_COLGRAPH(VARARGIN) assists in preparing your plots with the right
% colors for figures.
%
% See also PB_NICEGRAPH, PB_SELECTCOLOR, PB_COLORSTATS, PB_DEFSUBPLOT
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
    
    %% Initialize 
    
    fig     = pb_keyval('fig',varargin,gcf);
    def     = pb_keyval('def',varargin,2);
    
    cfn     = fig.Number;
    hstate  = ishold(cfn);
    
    %% Main
    
    [n,m,p] = pb_defsubplot(cfn);
    
    if ~isempty(p)
        ncol    = max(max(p));
        col     = pb_selectcolor(ncol,def);
        for iAx = 1:n*m
            subplot(n,m,iAx);
            h   = findobj(gca,'Type','Line');
            for iPl = length(h):1
                set(gca,'Color',color(iPl));
            end     
        end
    else
        close(cfn)
        fprintf('Current figure (%d) does not contain axes/plots.\n',cfn);
    end
    
    if ~hstate
        hold off
    end
    
  
 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

