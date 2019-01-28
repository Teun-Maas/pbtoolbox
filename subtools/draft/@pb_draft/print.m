function print(obj,varargin)
% PB_DRAFT>PRINT
%
% OBJ.PRINT will print a plot from the draft-figure.
%
% See also PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   v = varargin;
   
   h        = pb_keyval('h',v,obj(1).parent);
   cdir     = pb_keyval('cdir',v,[pb_datadir 'PhD' filesep 'Figures' filesep 'Figs' filesep]);
   fn       = pb_keyval('fn',v,defaultname(cdir));
   fit      = pb_keyval('fit',v,'-bestfit');
   format   = pb_keyval('format',v,'-dpdf'); 
   disp     = pb_keyval('disp',v,false);
   
   figure(h);
   loc = [cdir fn];
   print(fit,loc,format);
   
   if disp 
      open([loc '.' format(3:end)]);
   end
end

function fn = defaultname(cdir)
   %  Find first available filename
   
   cnt   = 1;
   fn    = 'default_f';
   hcd   = cd; 
   cd(cdir);

   while exist([fn num2str(cnt) '.pdf'],'file')
      cnt   = cnt+1;
   end
   fn    = [fn num2str(cnt)];
   cd(hcd);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

