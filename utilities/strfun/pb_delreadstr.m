function cnt = pb_delreadstr(str, varargin)
% PB_DELREADSTR(STR, VARARGIN)
%
% PB_DELREADSTR(STR, VARARGIN) reads nth-element from a string seperated by a delimiter.
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
    if isempty(str); return; end
    
    delimiter   = pb_keyval('delimiter',varargin,' ');
    n           = pb_keyval('n',varargin,1);
    
    D = strfind(str, delimiter);
    
    cnt = 0;
    
    for ind = 1:length(D)
        if ind == 1 && D(ind) > 1
            cnt = cnt+1;
            disp('1')
        elseif ind == length(D) && D(ind) < length(str)
            cnt = cnt+1;
            disp('end')
        else
                
        end
    end
    
    
    % INCLUDE MAIN CODE, for length(D), write strs then select nth element
    
 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

