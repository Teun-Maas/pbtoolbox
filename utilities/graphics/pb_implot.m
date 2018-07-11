function pb_implot(Idx, varargin)
% PB_IMPLOT(IDX, VARARGIN)
%
% PB_IMPLOT(IDX, VARARGIN) is a plot function that takes indices rather
% than x and y coordinates.
%
% See also PLOT
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


   if isempty(Idx); return; end
   
   h = pb_keyval('fig',varargin,gcf);

   plot()
   
 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

