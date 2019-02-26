function set_axcomp(obj,parameter,varargin)
% PB_DRAFT>SET_AXCOMP
%
% SET_AXCOMP(obj,row,col,varargin) creates subplots that compare over a
% selected parameter.
%
% See also PB_DRAFT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl


   if nargin <2 || isempty(parameter); return; end
   
   v           = varargin;
   orient      = pb_keyval('orientation',v,'horizontal');
   f.prefix    = pb_keyval('prefix',v);
   f.feature   = parameter;
   
   n           = length(unique(parameter));
   if strcmp('horizontal',orient); f.r = 1; f.c = n; else; f.r = n; f.c = 1; end
   
   obj(1).pva.axcomp = f;
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

