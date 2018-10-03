function pb_showStatColor(varargin)
% PB_SHOWSTATCOLOR(varargin)
%
% PB_SHOWSTATCOLOR(varargin) displays all color schemes of statcolor.
%
% See also PB_SELECTCOLOR, PB_STATCOLOR.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   fig      = pb_keyval('fig', varargin, 99);
   ncol     = pb_keyval('col', varargin, 10);
   ndef     = pb_keyval('def', varargin, 15);

   if ndef > 15; ndef = 15; end
   figure(fig); clf;
   
   list     = zeros(ndef,ncol,3);

   for i = 1:ndef
      RGB            = pb_statcolor(ncol,[],[],[],'def',i);
      [m,n]          = size(RGB);
      RGB            = reshape(RGB,1,m,n);
      list(i,:,:) 	= RGB;
   end
   image(list);
   ylabel('Definition'); 
   xlabel('Color');
   yticks(1:1:15);
end