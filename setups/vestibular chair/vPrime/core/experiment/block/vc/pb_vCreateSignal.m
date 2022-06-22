function D = pb_vCreateSignal(N, dur, SR, freq, type, varargin)
% PB_VCREATESIGNAL
%
% PB_VCREATESIGNAL(N, dur, SR, freq, type, varargin) creates an unscaled
% signal for the vestibular chair.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP, PB_VSIGNALVC.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   dshow    = pb_keyval('dshow',varargin,false);
   ax       = pb_keyval('axis',varargin);
   handles  = pb_keyval('handles',varargin,[]);
   
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
         case 'designed'
            [D(i).x,D(i).t] = VC_design(dur, SR,handles.cfg.fn_profile);
         otherwise
            error('False type specification');
      end
   end
   if dshow; pb_newfig(999); hold on; for i=1:N; plot(D(i).t,D(i).x); pb_nicegraph; end; end
end

%-- Specific signal functions --%
function [x,t] = VC_noisesignal(mu, dur, SR)
    % function generates a noise signal with mean mu, length dur and frequency freq.
    
    % noise signal
    sigma   =   0;
    t       =  (0:(dur*SR)-1)/SR;
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

function [x,t] = VC_sinesignal(dur, SR, freq)
    % function generates a sine signal

    w = freq*2*pi;
    t = (0:(dur*SR)-1)/SR;
    x = sin(w*t);
    
    tsz    	=   length(t);
    x       =   x .* tukeywin(tsz,0.25)';
end

function [x,t] = VC_predictedsine(dur, SR, freq) %%% <--- TO DO: FIX THE TRANSFER FUNCTION!!
    % function generates a perfect sine output
    
    t          = (0:(dur*SR)-1)/SR;
    xfun       = pb_y2x();
    
    tsz        =   length(t);
    x          =   xfun(1,freq,t) .* tukeywin(tsz,0.25)';
end

function [x,t]  = VC_turnsignal(dur, SR)
    % function will create turn signal of length dur
    
    t = (0:(dur*SR)-1)/SR;
    x = t;
end

function [x,t]  = VC_VOR(dur, SR)
    % function will create turn signal of length dur
    
   t     = (0:(dur*SR)-1)/SR;
   tsz   = length(t);
   th    = t(1:ceil(tsz/2));
   thsz  = length(th);

   %  Create velocity step profile (with tukeywin ramp)
   r     = 0.05;
   v     = ones(1,thsz);
   v     = v .* rot90(tukeywin(thsz,r));
   
   % add empty length
   v(end+1:tsz)   = 0;
   x              = cumsum(v)/SR;
end

function [x,t]  = VC_design(ax,SR,fn)
   % Function will create the designed signal that is uploaded as
   % vestibular_profile.mat within the same dir as the expfile
   
   t = inv(SR):inv(SR):200;
   
   % Assert vesti bular profile
   if isempty(fn); error('No vestibular profile was found'); end
   load(fn,'signal');                                                      % load
   
   % check if axis exists
   switch ax
      case 'VER'
         x = signal.VER;
      case 'HOR'
         x = signal.HOR;
      otherwise
         error('Not a proper axis selected (i.e. VER or HOR)');
   end
   
   if max(abs(x))>1; x = x/max(abs(x)); end                                % normalize (max value is 1)
   if size(t) ~= size(x); error('Dimensions t and x do not match.'); end   % Check if length matches
   
   tkw  = tukeywin(length(t),0.125);
   if any(abs(x)>tkw); x = x .* transpose(tkw); end                        % add tukeywindow if it is not there
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

