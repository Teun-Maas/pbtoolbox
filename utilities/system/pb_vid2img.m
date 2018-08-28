function D = pb_vid2img(varargin)
% D = PB_VID2IMG(varargin)
%
% PB_VID2IMG() allows you to select video data and convert it locally to a
% series of images. 
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


   %% Load Video
   extI  = {'*.avi;*.mov;*.mpg;*.mp4;*.m4v;*.mj2','Video Files'};
   extO  = pb_keyval('extO',varargin,'.png');
   cdir  = pb_keyval('cdir',varargin,'/Users/jjheckman/Documents/Data/PhD');

   [fname, path] = pb_getfile('dir',cdir,'ext',extI);
   if fname == 0; return; end
   
   %% Make directory
   [~,folder] = pb_fext(fname);
   D = [path folder];
   
   tmpD = D; cnt = 0;
   while isdir(tmpD) 
      cnt = cnt + 1;
      tmpD = [D '_Dupl' num2str(cnt)];
   end
   D = tmpD;
   mkdir(D);
   
   %% Convert video
   vObj = VideoReader([path fname]);
   
   cnt = 0;
   while hasFrame(vObj)
      cnt = cnt+1;
      img = readFrame(vObj);
      filename = [sprintf('%04d',cnt) extO];
      fullname = fullfile(D,filename);
      imwrite(img,fullname)    % Write out to a PNG file (img1.png, img2.png, etc.)
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

