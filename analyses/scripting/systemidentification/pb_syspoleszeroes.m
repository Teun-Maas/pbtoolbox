function [poles,zeroes] = pb_syspoleszeroes(sys, varargin)
% PB_SYSPOLESZEROES
%
% PB_SYSPOLESZEROES(sys) will create figure of
%
% See also ...

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl

   if ~isa(sys,'idtf'); return; end

   v = varargin;
   show     = pb_keyval('graph',v,1);

   % read poles and zeroes
   [num,denom,str]      = pb_splitTF(sys);
   poles                = vpasolve(denom);
   poles_R              = real(poles);
   poles_j              = imag(poles);   
   
   % read model str
   
   zeroes_R = [];
   zeroes_j = [];
   
   if hasSymType(num,'variable')
      zeroes         = vpasolve(num);   
      zeroes_R       = real(zeroes);
      zeroes_j       = imag(zeroes);
   end
   
   % graph
   if show
      % make graph
      cfn = pb_newfig(pb_cfn);
      title(['Pole (' num2str(length(poles_R)) ') / Zero (' num2str(length(zeroes_R)) ') plot']);
      axis square;
      hold on;
      
      plot(poles_R,poles_j,'Xb','MarkerSize',20,'Tag','Fixed');
      plot(zeroes_R,zeroes_j,'Ob','MarkerSize',20,'Tag','Fixed');
      
      xrange = double([-ceil(max(abs([poles_R; zeroes_R]))) ceil(max(abs([poles_R; zeroes_R])))]);
      yrange = double([-ceil(max(abs([poles_j; zeroes_j]))) ceil(max(abs([poles_j; zeroes_j])))]);
      
      xlim(xrange);
      if max(yrange) > 0
         ylim(yrange);
      end
      
      ylabel('$j \omega$');
      xlabel('$\mathcal{R}$');
      
      pb_nicegraph;
      pb_vline;
      pb_hline;
   end
   

end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

