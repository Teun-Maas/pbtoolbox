function x = pb_gaussfun(len,varargin)
% PB_GAUSSFUN
%
% PB_GAUSSFUN(len, varargin) simple GWN function.
%
% See also RANDN

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl
   
   v     = varargin;
   mu    = pb_keyval('mu',v,0);
   sigma = pb_keyval('sigma',v,1);
   P     = pb_keyval('P',v);
   
   if ~isempty(P); sigma = sqrt(P); end
   x     = sigma*rot90(randn(len,1))+mu;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

