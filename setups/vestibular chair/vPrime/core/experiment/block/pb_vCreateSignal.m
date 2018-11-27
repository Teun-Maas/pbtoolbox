function D = pb_vCreateSignal(N, dur, SR, freq, type, varargin)
% PB_VCREATESIGNAL(N, DUR, SR, FREQ, TYPE, VARARGIN)
%
% PB_VCREATESIGNAL(N, DUR, SR, FREQ, TYPE, VARARGIN) creates an unscaled
% signal for the vestibular chair.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP, PB_VSIGNALVC.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   dshow = pb_keyval('dshow',varargin,false);
   
   D(N) = struct;
   for i = 1:N
      switch type
         case 'none'
            [D(i).x,D(i).t] = VC_turnsignal(dur, SR);
            D(i).x = D(i).x .* 0;
         case 'noise' 
            [D(i).x,D(i).t] = VC_noisesignal(0, dur, SR);
         case 'sine'
            [D(i).x,D(i).t] = VC_sinesignal(dur, SR, freq);
         case 'predictsine'
            [D(i).x,D(i).t] = VC_predictedsine(dur, SR, freq);
         case 'turn'
            [D(i).x,D(i).t] = VC_turnsignal(dur, SR);
         case 'vor'
            [D(i).x,D(i).t] = VC_VOR(dur, SR);
         otherwise
            error('False type specification');
      end
   end
   if dshow; figure; hold on; for i=1:N; plot(D(i).t,D(i).x); pb_nicegraph; end; end
end

%-- Specific signal functions --%
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
    
    tsz    	=   length(t);
    x       =   x .* tukeywin(tsz,0.25)';
end

function [x,t] = VC_predictedsine(dur, SR, freq) %%% <--- TO DO: FIX THE TRANSFER FUNCTION!!
    % function generates a perfect sine output
    
    t = 0:1/SR:dur;
    xfun       = pb_y2x();
    
    tsz        =   length(t);
    x          =   xfun(1,freq,t) .* tukeywin(tsz,0.25)';
end

function [x,t]  = VC_turnsignal(dur, SR)
    % function will create turn signal of length dur
    
    t = 0:1/SR:dur;
    x = t;
end

function [x,t]  = VC_VOR(dur, SR)
    % function will create turn signal of length dur
    
    t = 0:1/SR:dur;
    x = t;
    
    tsz = length(t);
    ind = floor(tsz/2);
    x(ind+1:end) = x(ind);
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

