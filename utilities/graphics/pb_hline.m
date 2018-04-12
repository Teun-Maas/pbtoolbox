function h = pb_hline(y, varargin)
% PB_HLINE(Y)
%
% Plot a horizontal line through current axis.
%
% PB_HLINE(Y,'Style','LineSpec','Visability','VisibilitySpec') uses the color 
% and linestyle specified by the string 'LineSpec'. Default values for LineSpec 
% and VisibilitySpec are 'k--' & 'off', so that h remains unaffected by graphic 
% other function such as PB_NICEGRAPH. 
%
% See also PB_DLINE, PB_VLINE, PB_REVLINE, PB_NICEGRAPH

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


    %% Initialization

    if nargin < 1
        y = 0; 
    end
    
    style = pb_keyval('style',varargin,'k--');
    visibility = pb_keyval('visibility',varargin,'off');
    
    %% Plot

    y       = y(:)'; 
    ho = ishold; hold on;
    x_lim   = get(gca,'XLim');
    
    for i = 1:length(y)
        h(i)       = plot(x_lim, [y(i);y(i)], style);
    end
    
    %% Checkout
    set(h,'HandleVisibility',visibility); % set handle visibility
    if ~ho
        hold off;
    end
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

