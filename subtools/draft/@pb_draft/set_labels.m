function set_labels(obj,varargin)
% WRITETITLE()
%
% WRITETITLE()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   v = varargin;
   
   labels.xlab = pb_keyval('x',v,'');
   labels.ylab = pb_keyval('y',v,'');

   obj.labels = labels;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

