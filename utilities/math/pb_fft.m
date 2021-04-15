function [Y,f,P] = pb_fft(signal,fs,varargin)
% PB_FFT
%
% PB_FFT(signal,fs) generates a super fast plot of your the power spectrum
% with fft.
%
% See also FFT

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   display = pb_keyval('display',varargin,false);

   
   Y = fft(signal);
   L = length(Y);
   if ~iseven(L); L = L-1; end
   
   P2 = abs(Y/L);
   P1 = P2(1:L/2+1);
   P1(2:end-1) = 2*P1(2:end-1);
   P = P1;
   f = fs*(0:(L/2))/L; 
   
   if display
      pb_newfig(pb_cfn);
      plot(f,P) 
      title('Single-Sided Amplitude Spectrum of X(t)')
      xlabel('f (Hz)')
      ylabel('|P1(f)|')
      pb_nicegraph;
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

