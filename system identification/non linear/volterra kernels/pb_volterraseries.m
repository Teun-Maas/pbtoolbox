function [y,t] = pb_volterraseries(H,x,varargin)
% PB_VOLTERRASERIES
%
% PB_VOLTERRASERIES(H)  NOT YET CORRECT! WORKS FOR H1 (HIGHER ORDER IS
% MESSED UP!). COULD ALSO BE PB_GETVOLTERRAKERNELS
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   N = pb_keyval('order',varargin,length(H));
   
   DELAYS = length(H(2).kernel);

   % Get data parameters
   xlen = length(x);
   
   range    = 1:DELAYS;
   t        = DELAYS+1:length(x);

   y  = zeros(1,1000-DELAYS); % + H(1).kernel;
   for iS = 1:length(x)-DELAYS
      
      % Prep your sample memory
      current  = iS+DELAYS-1;
      range    = current-DELAYS+1:current;
      xin      = fliplr(x(range));  % relevant x's
      
      % H1
      sumt  = 0;
      for j1 = 1:DELAYS
         sumt =  sumt + (H(2).kernel(j1) * xin(j1));
      end
      y(iS) = y(iS) + sumt; 
      
      % H2
      sumt  = 0;
      for j1 = 1:DELAYS
         for j2 = 1:DELAYS
            sumt =  sumt + (H(3).kernel(j1,j2) * xin(j1)) * xin(j2);
         end
      end
      y(iS) = y(iS) + sumt; 
      
      % H3
      sumt  = 0;
      for j1 = 1:DELAYS
         for j2 = 1:DELAYS
            for j3 = 1:DELAYS
               sumt =  sumt + (H(4).kernel(j1,j2,j3) * xin(j1)) * xin(j2) * xin(j3);
            end
         end
      end
      y(iS) = y(iS) + sumt; 
      
      % H4
      sumt  = 0;
      for j1 = 1:DELAYS
         for j2 = 1:DELAYS
            for j3 = 1:DELAYS
               for j4 = 1:DELAYS
                  sumt =  sumt + (H(5).kernel(j1,j2,j3,j4) * xin(j1)) * xin(j2) * xin(j3) * xin(j4);
               end
            end
         end
      end
      y(iS) = y(iS) + sumt; 
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

