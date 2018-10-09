function pb_savefigs(varargin)
% PB_SAVEFIGS(varargin)
%
% PB_SAVEFIGS quickly saves all open figures into selected folder.  
%
% See also PB_SAVEFIG

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   prefix   = pb_keyval('prefix',varargin,'Fig_');
   dir      = pb_keyval('dir',varargin,'true');

   path = [pb_datadir 'PhD/Figure/'];
   if dir; path = pb_getdir('dir',path); end

   g = groot;
   h = flipud(g.Children); 

   for i = 1:length(h)
      pb_savefig('fig',h(i),'fname',[prefix num2str(i)],'dir',path);
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

