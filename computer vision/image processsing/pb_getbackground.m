function background_img = pb_getbackground(img_list,varargin)
% PB_GETBACKGROUND
%
% PB_GETBACKGROUND(img_list) computes the background image based on the
% number of samples 
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   %  Keyval
   v = varargin;
   nsamples = pb_keyval('nsamples',v,1);
   method   = pb_keyval('method',v,@mean);

   back_d   = zeros([nsamples size(im2double(imread(img_list(1).name)))]);
   for  iB = 1:nsamples
      img            	= imread(img_list(iB).name);
      back_d(iB,:,:,:)  = im2double(img);
   end

   if nsamples>1; back_d = method(back_d); end
   
   back_d            = squeeze(back_d);
   background_img    = im2uint8(back_d);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

