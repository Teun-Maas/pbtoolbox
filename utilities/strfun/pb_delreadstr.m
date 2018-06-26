function [strN] = pb_delreadstr(str, varargin)
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
    if isempty(D); strN = str; return; end
    N = length(D)-1;
    
    if D(1)>1
        N = N+1;
        D = [0 D];
    end
    
    if D(end) < length(str)
        N = N+1;
        D = [D length(str)+1];
    end
    
    if n>N
        error('Not enough elements in string.');
    end
    
    strN = str(D(n)+1:D(n+1)-1);
    
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

