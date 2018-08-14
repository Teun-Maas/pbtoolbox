function ax = pb_selectaxis(h)
% PB_SELECTAXIS(H)
%
% Creates a template function for PBToolbox.
%
% PB_SELECTAXIS(H)  selects axis from handle.
%
% See also PB_SELECTFIG, PB_IMPLOT
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if nargin==0; h = gca; return; end
   
   if isnumeric(h) 
      f = pb_fobj(gcf,'Type','Axes')
      tmp  = f(h);
      ax = set(gcf,'CurrentAxes',tmp); % DOES NOT WORK?
   elseif ~isgraphics(h)
      error('Input type for "h" should be either numeric or graphics');
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

