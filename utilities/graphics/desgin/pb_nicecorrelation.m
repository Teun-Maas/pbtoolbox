function pb_nicecorrelation(h, varargin)
% PB_NICECORRELATION()
%
% PB_NICECORRELATION()  ...
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
   if nargin == 0; h = gcf; end

   linewidth   = pb_keyval('linewidth',varargin,.5);
   style       = pb_keyval('style',varargin,'k--');
   origin      = pb_keyval('origin',varargin,[0 0]);

   ax = pb_fobj(h,'Type','Axes');
   n  = length(ax);

   for i = 1:n
      ax(n);
      pb_hline(origin(1),'style',style);
      pb_vline(origin(2),'style',style);
      pb_dline('style',style);
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

