function y = predict_volterra_series(obj,input)
% SET_POLYNOMIAL_METHOD()
%
% SET_POLYNOMIAL_METHOD()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl
   
   N        = length(obj.kernels);
   DELAYS   = obj.netpar.ninput - 1;

   % Get data parameters
   xlen     = length(input);
   t        = DELAYS:length(input)-1;

   %  pre-post processing: apply and reverse normalise to input and output data
   preprocess  = obj.process.normalisation.input;
   postprocess = obj.process.normalisation.output;
   
   input = preprocess(input);
   y     = zeros(1,length(input)-DELAYS);      % Pre-allocate output // NOTE: Should I add the h0 kernel?
   
   
   for iS = 1:length(input)-DELAYS
      
      %  Prep your sample memory
      current  = iS+DELAYS;
      range    = current-DELAYS:current;
      xin      = fliplr(input(range));  % relevant x's
      
      if N >= 2 
         % H1
         sumt  = 0;
         for j1 = 1:DELAYS
            sumt =  sumt + (obj.kernels(2).kernel(j1) * xin(j1));
         end
         y(iS) = y(iS) + sumt; 
      end
      
      if N >= 3 
         % H2
         sumt  = 0;
         for j1 = 1:DELAYS
            for j2 = 1:DELAYS
               sumt =  sumt + (obj.kernels(3).kernel(j1,j2) * xin(j1)) * xin(j2);
             end
         end
         y(iS) = y(iS) + sumt; 
      end
      
      if N >= 4
         % H3
         sumt  = 0;
         for j1 = 1:DELAYS
            for j2 = 1:DELAYS
               for j3 = 1:DELAYS
                  sumt =  sumt + (obj.kernels(4).kernel(j1,j2,j3) * xin(j1)) * xin(j2) * xin(j3); 
               end
            end
         end
         y(iS) = y(iS) + sumt; 
      end
      
      if N >= 5
         % H4
         sumt  = 0;
         for j1 = 1:DELAYS
            for j2 = 1:DELAYS
               for j3 = 1:DELAYS
                  for j4 = 1:DELAYS
                     sumt =  sumt + (obj.kernels(5).kernel(j1,j2,j3,j4) * xin(j1)) * xin(j2) * xin(j3) * xin(j4);
                  end
               end
            end
         end
         y(iS) = y(iS) + sumt; 
      end
      
      if N >= 6
         % H5
         sumt  = 0;
         for j1 = 1:DELAYS
            for j2 = 1:DELAYS
               for j3 = 1:DELAYS
                  for j4 = 1:DELAYS
                     for j5 = 1:DELAYS
                        sumt =  sumt + (obj.kernels(6).kernel(j1,j2,j3,j4,j5) * xin(j1)) * xin(j2) * xin(j3) * xin(j4) * xin(j5);
                     end
                  end
               end
            end
         end
         y(iS) = y(iS) + sumt; 
      end
      
      if N >= 7
         % H6
         sumt  = 0;
         for j1 = 1:DELAYS
            for j2 = 1:DELAYS
               for j3 = 1:DELAYS
                  for j4 = 1:DELAYS
                     for j5 = 1:DELAYS
                        for j6 = 1:DELAYS
                           sumt =  sumt + (obj.kernels(7).kernel(j1,j2,j3,j4,j5,j6) * xin(j1)) * xin(j2) * xin(j3) * xin(j4) * xin(j5) * xin(j6);
                        end
                     end
                  end
               end
            end
         end
         y(iS) = y(iS) + sumt; 
      end
   end
   
   y = postprocess(y);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

