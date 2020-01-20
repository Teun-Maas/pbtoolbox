function [slowphase,quickphase,VOR,stats] = pb_segmentVOR(eye,tsEye,head,tsHead,varargin)
% PB_SEGMENTVOR()
%
% PB_SEGMENTVOR()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   %%  Init

   v        = varargin;
   disp     = pb_keyval('disp',v,1);
   range    = pb_keyval('range',v,1:length(eye));
   
   fsPup    = 121.37; 
   fsSH     = 51.71;
   
   %%  Preprocess
   
   % Select data
%    eye      = eye(:);
%    head     = head(:);
   
   eye_vel              = gradient(eye) * fsPup;
   head_vel             = gradient(head) * fsSH; 
   
   if disp
      figure;
      hold on; 
      plot(tsEye, eye_vel);
      plot(tsHead, head);
      pb_nicegraph;
   end

   % Input data format                                        	% velocity profile of vc
   head_vel       = interp1(tsHead,head_vel,tsEye,'pchip');
   kInput         = eye_vel .* sign(head_vel);
   
   
   %%  Cluster
   
   
   %%  Postprocess
   
   
   %%  Checkout
   
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

