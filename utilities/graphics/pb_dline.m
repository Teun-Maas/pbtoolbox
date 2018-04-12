function h = pb_dline(varargin)
% PB_DLINE
%
% Plot a diagonal line through current axis.
%
% PB_DLINE('Style','LineSpec','Visability','VisibilitySpec') uses the color 
% and linestyle specified by the string 'LineSpec'. Default values for LineSpec 
% and VisibilitySpec are 'k--' & 'off', so that h remains unaffected by graphic 
% other function such as PB_NICEGRAPH. 
%
% See also PB_HLINE, PB_VLINE, PB_REVLINE, PB_NICEGRAPH

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


    %% Initialization

    style = pb_keyval('style',varargin,'k--');
    visibility = pb_keyval('visibility',varargin,'off');
    
    ho = ishold;
    if ~ho
        hold on
    end

    %% Set axis
    axxes		= axis;
    if axxes(1)~=axxes(3)
        min_x = min(axxes([1 3])); axxes([1 3]) = min_x;
    end
    if axxes(2)~=axxes(4)
        max_x = max(axxes([2 4])); axxes([2 4]) = max_x;
    end

    %% Plot diagonal
    
    h = plot([axxes(1) axxes(2)],[axxes(1) axxes(2)],style);
    set(h,'HandleVisibility',visibility); % set handle visibility
    if ~ho
        hold off
    end

end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 