function [x,y] = pb_rot2zero(x,y,varargin)
% PB_ROTEYE
%
% PB_ROTEYE(x,y)  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   xlen = length(x);
   ylen = length(y);
   
   if ~eq(xlen,ylen); error(['Vectors X & Y must be the same length (resp.' num2str(xlen) '-by-' num2str(ylen) ')']); end
   
   v           = varargin;
   axis2zero   = pb_keyval('axis2zero',v,'y');
   
   %  Rotate axis
   if strcmp(axis2zero,'y')
      a  = abs(y);
      b  = abs(x);
      c  = sqrt(a.^2 + b.^2);
      x  = sign(x) .* c;
      y  = zeros(size(x));
   else
      a  = abs(x);
      b  = abs(y);
      c  = sqrt(a.^2 + b.^2);
      y  = sign(y) .* c;
      x  = zeros(size(y));
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

