function [par,fun] = pb_sinefit(x,y,varargin)
% PB_SINEFIT()
%
% PB_SINEFIT()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   %  Get Varargin
   v           = varargin;
   frequency 	= pb_keyval('f',v);
   offset      = pb_keyval('offset',v,mean(y));
   amplitude   = pb_keyval('amplitude',v,0);
   phase       = pb_keyval('phase',v,0);
   disp        = pb_keyval('display',v,false);
   
   par         = zeros(1,4);
   
   % Obtain main freq
   nsamples    = length(x);
   T           = x(2)-x(1);
   NyFreq      = 1/(2*T);                                               % Nyquist frequency
   y_m         = y-offset;                                              % FFT much better without offset
   n           = 128*2^nextpow2(nsamples);                              % Heavy zero padding
   Y           = fft(y_m,n);                                            % Y(f)
   n2          = floor(n/2);
   P2          = abs(Y/nsamples);
   P1          = P2(1:n2+1);
   P1(2:end-1) = 2*P1(2:end-1);
   fs          = (0:n2)/n/T;                                            % frequency scale

   % %FFT parameters at peak
   [maxFFT,maxFFTindx]        = max(P1);                                % Peak magnitude and location
   fpeak                      = fs(maxFFTindx);                         % f at peak
   Phip                       = angle(Y(maxFFTindx))+pi/2;              % Phi-Peak is for cos, sin(90°+alpha)=cos(betta), alpha=-betta
   Phip                       = Phip-x(1)*fpeak*2*pi;               % shift for phi at x=0

   %Better estimate for offset:
   omega    = 2*pi*fpeak;
   offset   = offset - maxFFT*(cos(omega*x(1)+Phip)-cos(omega*x(end)+Phip))/(omega*(x(end)-x(1)));

   %  Knowit all mode
   if isempty(frequency)
      frequency = fpeak;
   end

   %  Set parameters
   par(1) = offset;
   par(2) = amplitude;
   par(3) = frequency;
   par(4) = phase;
   
   %  Fake parameters
   par(1) = -8;
   par(2) = 24.2;
   par(4) = -.28;
   
   if disp
      graphFit(x,y,par)
   end
end

function graphFit(x,y,par)
   %  Create fits
   t = x;
   f = par(1) + par(2) * sin(2*pi*par(3)*t +par(4));
   
   %  Plot
   cfn = pb_newfig(pb_cfn);
   hold on;
   raw = plot(x,y,'.');          % Rawdata
   fit = plot(t,f);              % Fit
   
   pb_nicegraph;
   fit.LineWidth = 2;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
