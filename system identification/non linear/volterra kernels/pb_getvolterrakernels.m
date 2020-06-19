function H = pb_getvolterrakernels(net, varargin)
% PB_GETVOLTERRAKERNELS
%
% PB_GETVOLTERRAKERNELS(net)  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl
   
   N = pb_keyval('order',varargin,4);

   % Extract weights en bias from net
   c     = net.LW{2,1};
   w     = net.IW{1,1};
   
   % Calculate Polynomial a coefficients arround the bias
   a     = pb_coeff_a(net);
   
   % Make sure you don't over do the max amount of kernels (memory explosion!)
   maxkernel = 7;
   if N > maxkernel; N = maxkernel; end
   if N > size(a,1)-1   % minus 1, for the 0th order first indices matlab (tau starts at 0!)
      N = size(a,1)-1;
   end

   % Run kernels
   H = struct([]);
   for iN = 1:N+1
      H(iN).kernel   = currentkernel(c,a,w,iN-1);
      H(iN).order    = iN-1; 
   end
end

function k = currentkernel(c,a,w,n)
   % Returns the nth order kernel
   
   [DELAYS, NODES] = size(a);
   
   switch n    % Get the nth order kernel calculation
      
      case 0   % h0
         % 0th order volterra kernel
         k = sum(c .* a(n+1,:));
         
         
      case 1   % h1 
         % 1st order volterra kernel
         k    = zeros(1,length(a)); % 1-D
         for j1 = 1:DELAYS
            s = 0;
            for i = 1:NODES
               s = s + c(i) .* a(n+1,i) .* w(i,j1);
            end
            k(j1) =  s;
         end
         
         
      case 2   % h2 
         % 2nd order volterra kernel
         k    = zeros(length(a)); % 2-D
         for j1 = 1:DELAYS
            for j2 = 1:DELAYS
               s = 0;
               for i = 1:NODES
                  s = s + c(i) .* a(n+1,i) .* w(i,j1) * w(i,j2);
               end
               k(j1,j2) =  s;
            end
         end
         
         
      case 3   % h3
         % 3rd order volterra kernel 
         k    = zeros(length(a),length(a),length(a)); % 3-D
         for j1 = 1:DELAYS
            for j2 = 1:DELAYS
               for j3 = 1:DELAYS
                  s = 0;
                  for i = 1:NODES
                     s = s + c(i) .* a(n+1,i) .* w(i,j1) * w(i,j2) * w(i,j3);
                  end
                  k(j1,j2,j3) =  s;
               end
            end
         end
         
         
      case 4   % h4
         % 4th order volterra kernel
         k    = zeros(length(a),length(a),length(a),length(a)); % 4-D
         for j1 = 1:DELAYS
            for j2 = 1:DELAYS
               for j3 = 1:DELAYS
                  for j4 = 1:DELAYS
                     s = 0;
                     for i = 1:NODES
                        s = s + c(i) .* a(n+1,i) .* w(i,j1) * w(i,j2) * w(i,j3) * w(i,j4);
                     end
                     k(j1,j2,j3,j4) =  s;
                  end
               end
            end
         end
         
         
         
      case 5   % h5
         % 5th order volterra kernel
         k    = zeros(length(a),length(a),length(a),length(a),length(a)); % 5-D
         for j1 = 1:DELAYS
            for j2 = 1:DELAYS
               for j3 = 1:DELAYS
                  for j4 = 1:DELAYS
                     for j5 = 1:DELAYS
                        s = 0;
                        for i = 1:NODES
                           s = s + c(i) .* a(n+1,i) .* w(i,j1) * w(i,j2) * w(i,j3) * w(i,j4) * w(i,j5);
                        end
                        k(j1,j2,j3,j4,j5) =  s;
                     end
                  end
               end
            end
         end
         
         
      case 6   % h6
         % 6th order volterra kernel
         k    = zeros(length(a),length(a),length(a),length(a),length(a),length(a)); % 6-D
         for j1 = 1:DELAYS
            for j2 = 1:DELAYS
               for j3 = 1:DELAYS
                  for j4 = 1:DELAYS
                     for j5 = 1:DELAYS
                        for j6 = 1:DELAYS
                           s = 0;
                           for i = 1:NODES
                              s = s + c(i) .* a(n+1,i) .* w(i,j1) * w(i,j2) * w(i,j3) * w(i,j4) * w(i,j5) * w(i,j6);
                           end
                           k(j1,j2,j3,j4,j5,j6) =  s;
                        end
                     end
                  end
               end
            end
         end
         
         case 7   % h7
         % 7th order volterra kernel
         k    = zeros(length(a),length(a),length(a),length(a),length(a),length(a),length(a)); % 7-D
         for j1 = 1:DELAYS
            for j2 = 1:DELAYS
               for j3 = 1:DELAYS
                  for j4 = 1:DELAYS
                     for j5 = 1:DELAYS
                        for j6 = 1:DELAYS
                           for j7 = 1:DELAYS
                              s = 0;
                              for i = 1:NODES
                                 s = s + c(i) .* a(n+1,i) .* w(i,j1) * w(i,j2) * w(i,j3) * w(i,j4) * w(i,j5) * w(i,j6) * w(i,j7);
                              end
                              k(j1,j2,j3,j4,j5,j6,j7) =  s;
                           end
                        end
                     end
                  end
               end
            end
         end
         
   end
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

