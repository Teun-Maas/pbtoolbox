function pb_shadedline(D,varargin)
% PB_SHADEDLINE()
%
% PB_SHADEDLINE()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   fig      = pb_keyval('fig',varargin,gcf);
   ax       = pb_keyval('axis',varargin,gca);
   col      = pb_keyval('col',varargin);
   alpha    = pb_keyval('alpha',varargin,.3);
   smooth   = pb_keyval('smooth',varargin,1);
   
   figure(fig); 
   axes(ax);
   
   hs = ~ishold;
   hold on; 
   
   F = 1 : size(D,2);

   if ne(size(F,1),1)
       F=F';
   end

   amean=smooth(nanmean(D),smth)';
   astd=nanstd(D);                                                   % to get std shading
   % astd=nanstd(amatrix)/sqrt(size(amatrix,1));                           % to get sem shading

   if exist('alpha','var')==0 || isempty(alpha) 
       fill([F fliplr(F)],[amean+astd fliplr(amean-astd)],acolor,'linestyle','none');
       acolor='k';
   else
      fill([F fliplr(F)],[amean+astd fliplr(amean-astd)],acolor, 'FaceAlpha', alpha,'linestyle','none');
   end

   plot(F,amean,acolor,'linewidth',1.5); %% change color or linewidth to adjust mean line
   if hs; hold off; end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

