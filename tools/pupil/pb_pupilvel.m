function [vel,smv, R] = pb_pupilvel(az,el,fs)
% PB_PUPILVEL()
%
% PB_PUPILVEL()  ...
%
% See also ...

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl

   az    = pb_naninterp(az);
   el    = pb_naninterp(el);

   % Get the dimensionless movement, R.
   Rx                                     = az;
   Ry                                     = el;
   R                                      = NaN*Rx;
   vel                                    = R;

   % Compute velocty
   Rx(:)                                  = gradient(Rx(:),1);
   Ry(:)                                  = gradient(Ry(:),1);
   R(:)                                   = hypot(Rx(:),Ry(:));
   R(:)                                   = cumsum(R(:));

   vel(:)                                 = gradient(R(:),1./fs);
   smv                                    = getsmooth(vel,fs);
 end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function smv    = getsmooth(vel,fs)
   % This function will smooth the velocity trace to allow rough automatic
   % saccade detection

   % defaults
   sd       = 0.01;
   sdextra  = 5;

   % Get velocity
   x           = vel(:)';
   nextra      = round(sdextra*sd*fs);
   nx          = length(x);
   nfft        = nx+2*nextra;

   if rem(nfft,2)    % nfft odd
       frq     = [0:(nfft-1)/2 (nfft-1)/2:-1:1];
   else
       frq     = [0:nfft/2 nfft/2-1:-1:1];
   end
   x           = [x(nextra+1:-1:2) x x(end:-1:end-nextra+1)];           % mirror edges to go around boundary effects

   % Determine gaussian
   g           = normpdfun(frq,0,sd*fs);
   g           = g./sum(g);

   y           = real(ifft(fft(x).*fft(g)));
   smv       	= y(nextra+1:end-nextra);
end

