function h = pb_fobj(varargin)
% PB_FOBJ(varargin)
%
% PB_FOBJ(varargin) returns the flipud of an object array. This allows for
% more ease during figure editing, as obj will be sorted logically.
%
% See also FINDOBJ, FLIPUD, PB_NICEGRAPH, PB_CLONEFIG
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   h = flipud(findobj(varargin{:}));
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

