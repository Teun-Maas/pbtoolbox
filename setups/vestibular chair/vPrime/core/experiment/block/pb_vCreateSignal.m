function D = pb_vCreateSignal(N, dur, SR, freq, type, varargin)
% PB_VCREATESIGNAL()
%
% PB_VCREATESIGNAL()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   dshow = pb_keyval('dshow',varargin,false);
   
   D(N) = struct;
   for i=1:N
      switch type
         case 'noise' 
            [D(i).x,D(i).t] = VC_noisesignal(0, dur, SR);
         case 'sine'
            [D(i).x,D(i).t] = VC_sinesignal(dur, SR, freq);
         case 'predictsine'
            [D(i).x,D(i).t] = VC_predictedsine(dur, SR, freq);
         case 'turn'
            [D(i).x,D(i).t] = VC_turnsignal(dur, SR);
         otherwise
            error('False type specification');
      end
   end
   if dshow; figure(); hold on; for i=1:N; plot(D(i).t,D(i).x); pb_nicegraph; end; end
end

function [x,t] = VC_noisesignal(mu, dur, SR)
    % function generates a noise signal with mean mu, length dur and frequency freq.
    
    % noise signal
    sigma   =   0;
    t       =   0:1/SR:dur;
    x       =   mu+sigma;
    x       =   x+randn(length(t),1);

    % cheby filtered signal
    n       =   12; 
    Ws      =   1;
    Rs      =   80; 
    LPfil   =   designfilt('lowpassiir', 'FilterOrder', n,...
                           'StopbandFrequency', Ws,...
                           'StopbandAttenuation', Rs,...
                           'SampleRate', 10);                   
    x  =   filtfilt(LPfil,x);

    % tukey window 
    L       =   length(t);
    x       =   x.* tukeywin(L,0.25);
    
end

function [x,t] = VC_sinesignal(dur, SR, freq)

    % function generates a sine signal

    w = freq*2*pi;
    t = 0:1/SR:dur;
    x = sin(w*t);
    
    L       =   length(t);
    x       =   x.* tukeywin(L,0.25)';
    
    
end

function [x,t] = VC_predictedsine(dur, SR, freq)

    % function generates a sine signal that in theory should generete an
    % perfect sine output: y(t)=sin(wt).
    
    a = 1.39;
    b = 1.4;
    w = freq*2*pi;
    
    t = 0:1/SR:dur;
    x = (b*sin(w*t) + w*cos(w*t))/a;
    
    L       =   length(t);
    x       =   x.* tukeywin(L,0.25)';
    
end

function [x,t]  = VC_turnsignal(dur, SR)
    
    % function will create turn signal of length dur
    
    t = 0:1/SR:dur;
    v = randn(1,1);
    x = v*t;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

