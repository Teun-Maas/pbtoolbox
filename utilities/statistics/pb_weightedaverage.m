function wavg = pb_weightedaverage(data,weights,varargin)
% PB_WEIGHTEDAVERAGE()
%
% PB_WEIGHTEDAVERAGE()  ...
%
% See also ...

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl

   v = varargin;
   direction   = pb_keyval('direction',v,1);
 
   wavg        = sum((data .* weights))/sum(weights);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

