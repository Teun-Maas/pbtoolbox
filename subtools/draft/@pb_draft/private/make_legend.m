function make_legend(obj,varargin)
% PB_DRAFT>MAKE_LEGEND
%
% OBJ.MAKE_LEGEND(varargin) rescale, size and store axes handles..
%
% See also PB_DRAFT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl
   
   lgnd = obj(1).h_ax_legend;
   if lgnd.bool
      h = axes('Units','Normal','Position',[.8 .3 .15 .4],'Visible','off','tag','legend');
      hold on;
      t = text(0,0.5,'LEGEND1','Visible','on');
      p = plot(0,0.5,'o','Visible','on');
      xlim = [0 1];
      ylim = [0 1];


      %[n,m] = readlegend(lgnd.features.entries,lgnd.features.fontsize);
   end
end


function [n,m] = readlegend(entries,fontsize)
   % returns the size of the legend
   
   if isempty(entries)
      n = 0; m = 0;
      return
   end
   
   n        = length(entries);
   n        = (n+1)*0.04;

   
   z = axes();
   set(z,units,'centimeters');
   
   
   
   
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
