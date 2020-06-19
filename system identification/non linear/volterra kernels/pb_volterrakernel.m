function [hn,order] = pb_volterrakernel(net, order, a)
% PB_VOLTERRAKERNEL()
%
% PB_VOLTERRAKERNEL()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   % Get nargins
   if nargin < 3; a = pb_coeff_a(net); end
   if nargin < 2; order = 0; end
   
   % Get weights
   ci    = net.LW{2,1}';   % Linear
   wji   = net.IW{1,1};    % Non-linear
   
   %  hn(v1,..,vn) = sum(ci * ani * wv1i * ... * wvni)
   
   
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

