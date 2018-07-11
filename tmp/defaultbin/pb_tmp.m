%% clearup

close all
clear

%% load vars 

vidObj   = VideoReader(pb_getfile('dir','/Users/jjheckman/Documents/Data/PhD/mouse'));
figure(999);



%% detect edge remove edge

clf;
fN = 1;
frame    = read(vidObj,fN);
frame    = rgb2gray(frame);
border   = 50;
frame    = frame(border:end-border,border:end-border);
frame    = imsharpen(frame);

% binary img

bwM = imbinarize(frame,.4);
bwE = imbinarize(frame,.33);

% remove noise
bwM = bwareaopen(bwM,10); 
bwM = ~bwareaopen(~bwM,500);  
bwE = bwareaopen(bwE,10);
bwE = ~bwareaopen(~bwE,500);

% %plot
% subplot(211); imshow(bwM); title('Mice')
% subplot(212); imshow(bwE); title('Ears')
% 
% %%

clf; 
imshow(bwM);
CC = bwconncomp(~bwM)


%% find difference between both

diff = bwM ~= bwE;
figure(1);
imshow(~diff)

%% Edge

bwM = ~edge(~bwM,'Canny');
imshow(bwM);



% find ears

rMin = 6; rMax = 15;
[centersBright, radiiBright] = imfindcircles(bwM,[rMin rMax],'ObjectPolarity','bright');
h = viscircles(centersBright, radiiBright,'Color','r');
h = h.Children;
h(1).LineStyle = '-';
h(1).LineWidth = 1;



%%

bw2 = imcomplement(bi_frame);
bw2 = imfill(bw2,'holes');






 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

