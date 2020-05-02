function gwn = pb_gwn(N,varargin)
% PB_GWN
%
% PB_GWN(N,varargin) reverse engineers a gaussian white noise pattern based
% on a wanted spectrum.
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   %  Various arguments in
   v = varargin;
   shuffle  = pb_keyval('shuffle',v,true);
   Fc       = pb_keyval('fc',v,0.5);
   Fs       = pb_keyval('fs',v,10); 
   order    = pb_keyval('order',v,500); 
   filter   = pb_keyval('filter',v,'lowpass');
   mu       = pb_keyval('mu',v,0);
   display  = pb_keyval('display',v,false);
   
   %  reset random noise generator
   if shuffle
      rng('shuffle');
   end

   %  Generate noise
   NFFT	= 2^(nextpow2(N));
   M		= repmat(100,NFFT/2,1);
   M		= [M;flipud(M)];
   P		= (rand(NFFT/2,1)-0.5)*2*pi;
   P		= [P;flipud(P)];

   R		= M.*cos(P);
   I		= M.*sin(P);
   S		= complex(R,I);

   %  Reverse to time domain
   gwn	= ifft(S,'symmetric');
   gwn   = gwn + mu;
   
   switch filter
      case 'lowpass'
         gwn   = lowpass(gwn,'Fc',Fc,'Fs',Fs,'order', order); % Low-pass filter
      case 'highpass'
         gwn   = highpass(gwn,'Fc',Fc,'Fs',Fs,'order',order); % High-pass filter  
   end
         
   if display
      [~,f,P] = pb_fft(gwn,10,'display',false);

      pb_newfig(pb_cfn);
      sgtitle('Gausian White Noise','FontSize',20)
      subplot(211);
      hold on;
      plot(gwn,'Color',[0.8 0.8 0.8],'Tag','Fixed','LineWidth',1);
      xlabel('Sample $(\#)$');
      ylabel('Gain');
      ylim([-2 2])
      xlim([0 length(gwn)])

      subplot(212);
      hold on;
      plot(f,P,'Color',[0.8 0.8 0.8],'Tag','Fixed','LineWidth',1);
      xlim([0 1]);
      xlabel('Frequency (Hz)');
      ylabel('Power')

      pb_nicegraph;
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

