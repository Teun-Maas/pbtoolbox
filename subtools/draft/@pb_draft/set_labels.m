function set_labels(obj,varargin)
% PB_DRAFT>SET_LABELS
%
% OBJ.SET_LABELS()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   v = varargin;
   
   labels.xlab       = pb_keyval('x',v,'');
   labels.ylab       = pb_keyval('y',v,'');
   labels.suplabel   = pb_keyval('suplabels',v);

   obj.labels = labels;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

