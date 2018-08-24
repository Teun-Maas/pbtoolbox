function D = pb_iTF(y,varargin)
% PB_ITF()
%
% PB_ITF()  ...
%
% See also PB_Y2X

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% Initialize
   
   if nargin == 0; syms y A w t; y = A*sin(w*t); end
   
   amplitude   = pb_keyval('amplitude',varargin,1);
   omega       = pb_keyval('omega',varargin,1);
   dur         = pb_keyval('dur',varargin,30);
   sr          = pb_keyval('sr',varargin,10);
   
   %% Body
   x = pb_y2x(y);
   T = 0:1/sr:dur;
    
   xfun  = matlabFunction(x); % x = F[y(t)]
   yfun  = matlabFunction(y); % y = A * sin(w*t)
   
   D.tfun   = x;
   D.t      = T;
   D.x      = xfun(amplitude,T,omega);
   D.py     = yfun(amplitude,T,omega);
    
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

