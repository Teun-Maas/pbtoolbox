function x = pb_filtnoise(mu, dur, SR)
% PB_FILTNOISE()
%
% PB_FILTNOISE()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   % noise signal
   sigma   =   0;
   t       =   0:1/SR:dur;
   x       =   mu+sigma;
   x       =   x+randn(length(t),1);

   % cheby filtered signal
   n       =   10; 
   Ws      =   1;
   Rs      =   80; 
   LPfil   =   designfilt('lowpassiir', 'FilterOrder', n,...
                        'StopbandFrequency', Ws,...
                        'StopbandAttenuation', Rs,...
                        'SampleRate', SR);                   
   x  =   filtfilt(LPfil,x);

   % tukey window 
   L       =   length(t);
   x       =   x.* tukeywin(L,0.25);
   end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

