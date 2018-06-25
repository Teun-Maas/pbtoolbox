function D = pb_delreadstr(str, varargin)
% PB_DELREADSTR(STRING, VARARGIN)
%
% PB_DELREADSTR() reads nth-element from a string seperated by a delimiter.
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
    if isempty(str); return; end
    
    delimiter   = pb_keyval('delimiter',varargin,'-');
    n           = pb_keyval('n',varargin,1);
    
    D = strfind(str,delimiter);
    
    % INCLUDE MAIN CODE, for length(D), write strs then select nth element
    
 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

