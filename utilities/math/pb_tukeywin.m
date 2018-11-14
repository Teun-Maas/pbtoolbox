function signal = pb_tukeywin(signal, varargin)
% PB_TUKEYWIN()
%
% PB_TUKEYWIN()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   % Keyval pairs
   vel = pb_keyval('velocity',varargin,0.33);

   % Orient signal
   signalsz = size(signal);
   if signalsz(2)>signalsz(1)
      signal = signal'; 
   end
   
   tk = tukeywin(max(signalsz),vel);
   signal = signal .* tk;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

