function pb_lightviewer(varargin)
% PB_LIGHTVIEWER
%
% PB_LIGHTVIEWER(varargin) simulates lightshows in the vestibular chair
%
% See also PB_LIGHTSHOW

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   h           = pb_keyval('fig',varargin,pb_newfig(998));
   lightshow   = pb_keyval('lightshow',varargin,'default');
   leds        = pb_keyval('leds',varargin,-45:5:45);
   freq          = pb_keyval('freq',varargin,.15);
   
   clf; hold on;
   axis square
   
   set(gca,'Color','k')
   set(gca,'YTickLabel',[]);
   set(gca,'XTickLabel',[]);
   set(h, 'Units', 'Normalized');
   set(h, 'OuterPosition', [.1, .1, .85, .85]);
   xlim([-50 50]);
   
   switch lightshow
      case 'default'
         ls          = struct;
         ls(1).seq   = 1:2:19;
         ls(2).seq   = 2:2:18;
   end
         
   
   run_show(h,ls,leds,freq);
end

function run_show(h,ls,leds,freq)
   n = 8;
   for idx = 1:n
      if mod(idx,length(ls)) == 0
         x = ls(1).seq;
         y = zeros(length(x));
         plot(leds(x),y,'og','MarkerFaceColor','g');
         pause(freq);
         cla;
         pause(freq);
      else
         x = ls(2).seq;
         y = zeros(length(x));
         plot(leds(x),y,'or','MarkerFaceColor','r');
         pause(freq);
         cla;
         pause(freq);
      end
      
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

