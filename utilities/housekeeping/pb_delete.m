function pb_delete(varargin)
% PB_DELETE(varargin)
%
% PB_DELETE(varargin) deletes the last handle from a graphic object.
%
% See also PB_FOBJ

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   %type  = pb_keyval('Type',varargin,'line');
   ax    = pb_keyval('Axis',varargin,gca);
   num   = pb_keyval('number',varargin,1);
   
   h = pb_fobj(ax);
   
   cnt = 0;
   len = length(h);
   
   for iH = 1:len
      if contains(h(iH).Type,'axes') || contains(h(iH).Type,'figure')
         cnt = cnt+1;
      end
   end
   for iN = 1:num
      delete(h(length(h)-cnt));
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

