function bool = pb_and(logicArray)
% PB_AND()
%
% Iterates 'and'-logical operation on all elements of input argument.
%
% PB_AND(LOGIC)  returns true when all elements are true, if any elements
% is false it returns false. If no input was provided, it returns false.
%
% See also PB_OR
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
    if nargin <1
        bool = false;
        return
    end
    
    logicArray = logicArray(:);
    bool = logicArray(1);
    for i=1:length(logicArray)-1
        logicArray = logicArray(2:end);
        bool = and(bool,logicArray(1));
    end
 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

