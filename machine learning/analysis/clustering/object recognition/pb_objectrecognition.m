%% Initialize

cfn = pb_clean;
pos = [1850, 968, 470, 470];

cd('/Users/jjheckman/Desktop/');
warning('off','images:imshow:magnificationMustBeFitForDockedFigure');

%% Run screen recording

%  Connect iPhone
questdlg('Are you ready?','Connect your iPhone to screen','Yes','Cancel','Yes');
p = [pb_userpath 'subtools/webcam/applications/'];
system(['open -a ' p 'runScreenRecording.app']);

%  Select Camera 
questdlg('Are you ready?','Is your camera selected to iPhone','Yes','Cancel','Yes');
p = [pb_userpath 'subtools/webcam/applications/'];
system(['open -a ' p 'fixPhoneScreen.app']);

%% Read in data

%  NN
nnet   = alexnet;

%  Display
cfn = pb_newfig(cfn);
while true
   img   = ScreenCapture(pos);
   img   = imresize(img,[227,227]);
   label = classify(nnet,img);
   
   image(img);
   axis square;
   title(char(label));
   drawnow;
   pause(inv(48))
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

