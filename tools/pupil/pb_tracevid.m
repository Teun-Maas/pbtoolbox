function pb_tracevid(x,y,T,varargin)
% PB_TRACEVID()
%
% PB_TRACEVID()  ...
%
% See also ...

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl

   v           = varargin;
   xlab        = pb_keyval('xlab',v,'Azimuth ($^{\circ}$)');
   ylab        = pb_keyval('xlab',v,'Elevation ($^{\circ}$)');
   limx        = pb_keyval('xlim',v,[-50 50]);
   limy        = pb_keyval('ylim',v,[-50 50]);
   fsize       = pb_keyval('fontsize',v,20);
   nsample     = pb_keyval('nsample',v,300);
   fs          = pb_keyval('fs',v,400);
   markerstyle = pb_keyval('markerstyle',v,'.');
   
   
   
   gcf; clf;
   fig = gca;
   hold on;
   title('Trace video','fontsize',fsize);
   
   if any(xlab); xlabel(xlab,'fontsize',fsize-5); end
   if any(ylab); ylabel(ylab,'fontsize',fsize-5); end
   if any(limx); xlim(limx); end
   if any(limy); ylim(limy); end
   
   fig.YLimMode   = 'manual';
   fig.XLimMode   = 'manual';
   
   
   for iH = 1:min(size(x))
      h(iH) = plot(x(iH,1:nsample),y(iH,1:nsample),markerstyle);
   end
   
   if ~isempty(T.targets); plot(T.targets(:,1),T.targets(:,2),'ok','markersize',20,'tag','Fixed'); end
   legend('eye trace 2D');
   
   pb_nicegraph;
   play_video(h,x,y,fs,T,nsample);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function play_video(h, x,y,fs,T,nsample)
   
   cnt = 1;
   for iD = 2:length(x)-nsample
      
      if T.timestamp(iD+nsample)
         plot(T.targets(cnt,1),T.targets(cnt,2),'Marker','o','markerfacecolor','k','markersize',20);
         pause(.1)
         pb_delete;
         cnt = cnt+1;
      end
      
      for iH = 1:min(size(x)) 
         h(iH).XData = x(iH,iD:iD+nsample-1);
         h(iH).YData = y(iH,iD:iD+nsample-1);
      end
      pause(1/fs);
   end
end