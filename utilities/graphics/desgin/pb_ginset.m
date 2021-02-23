function pb_ginset(h,varargin)
% PB_GINSET
%
% PB_GINSET(H)  ...
%
% See also ...

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl

   if nargin == 0; h = gcf; end
   if ~isgraphics(h); return; end
   
   GV.scale = pb_keyval('scale',varargin,3);
   
   % Select graphics handle(s)
   switch h.Type
      case 'figure'
      h = pb_fobj(h,'Type','Axes','-not','Tag','Inset');
      case 'axes'
      otherwise
         return
   end
   
   h_insets = inset_axes(h,GV);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function h_insets = inset_axes(h,GV)
   % Plug in insets
   
   for iA = 1:length(h)
      h_insets(iA) = copyobj(h(iA),h(iA).Parent);
      h_insets(iA).Position = h_insets(iA).Position/GV.scale;
      h_insets(iA).Tag = 'Inset';
   end
end