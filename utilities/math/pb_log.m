function C = pb_log(B, A)
% PB_LOG(B,A)
%
% Returns the value of A-log(B).
%
% PB_LOG(B,A) returns the logaritmic value of A-log(B), i.e. log(B)/log(A).
% if no value is provided for A, the natural log is assumed.
%
% See also PB_LOGSPACE
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
   if nargin == 2
      C = log(B)/log(A);
   else
      C = log(B);
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

