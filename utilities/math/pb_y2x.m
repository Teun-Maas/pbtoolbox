function x = pb_y2x(varargin)
% PB_Y2X(varargin)
%
% PB_Y2X(varargin) returns a matlabFunction to achieve a wanted vestibular 
% output. Note that if no input arguments are provided. Transfer function
% and wanted output are chosen by default parameters.
%
% See also PB_VCREATESIGNALS, MATLABFUNCTION

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   syms x y h X H Y s t w a f

   def = loaddefaults;
   
   H = pb_keyval('H',varargin,def.H);
   y = pb_keyval('y',varargin,def.y);
   
   Y = laplace(y);
   X = Y/H;
   x = ilaplace(X);
   x = matlabFunction(x);
end

function def = loaddefaults
% Default functions for keyval
   syms x y h X H Y s t w a f
   
   w = f*2*pi;
   
   def.H = (2*s + 0.015)/(s^2 + 2*s + 0.015);   % default transfer function VC
   def.y = a*sin(w*t);                          % default output VC (sine)
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

