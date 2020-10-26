function [ir,D] = pb_noise2h(input,output,varargin)
% PB_NOISE2H
%
% PB_NOISE2H()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   if size(input) ~= size(output); error('Input and output matrices are not identical in size.'); end
 
   for iN = 1:size(input,1)
      memory = pb_keyval('memory',varargin,25);
      
      % Compute effective ROI
      x        = input(iN,:); % remove tukeywin
      y        = output(iN,:);
      
      %  Compute IR
      [r,d]          = xcorr(y,x,'normalized');
      offset         = find(d>max(r),1);
      offset         = ceil(length(d)/2);
      r              = r/var(x);
      ir             = r(offset:end);
      D(iN).ir       = ir(1:memory);
      
   end
   ir = mean(vertcat(D.ir));
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

