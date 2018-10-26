function pb_delete(varargin)
% PB_DELETE(varargin)
%
% PB_DELETE(varargin) deletes the last handle from a graphic object.
%
% See also PB_FOBJ

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   type  = pb_keyval('Type',varargin,[]);
   ax    = pb_keyval('Axis',varargin,gca);
   
   h = pb_fobj(ax,'Type',type);
   
   cnt = 0;
   len = length(h);
   
   for iH = 1:len
      if contains(h(iH).Type,'axes') || contains(h(iH).Type,'figure')
         cnt = cnt+1;
      end
   end
   delete(h(length(h)-cnt));
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

