function bool = pb_and(logic)
% PB_AND(LOGIC)
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
    
    logic = logic(:);
    bool = logic(1);
    for i=1:length(logic)-1
        logic = logic(2:end);
        bool = and(bool,logic(1));
    end
 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

