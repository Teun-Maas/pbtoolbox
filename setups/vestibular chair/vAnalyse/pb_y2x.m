function x = pb_y2x(y,H)
% PB_Y2X(y, H)
%
% PB_Y2X() transforms the symbolic wanted output expression to a symbolic
% required input expression, using Laplace transformation and the system's
% transfer function.
%
% See also PB_ITF

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   syms s t x X Y 

   if nargin == 1 
      % if no tf was provided select default parameters (tf2 for VC model dat with ampl. 15).
      syms H s N D
      N(s) =  2.002*s + 0.01492; 
      D(s) =  s^2 + 2.009*s + 0.0145;
      H(s) = N/D;
   end

   Y(s) = laplace(y);
   X(s) = Y(s)/H(s);

   x = ilaplace(X(s));
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

