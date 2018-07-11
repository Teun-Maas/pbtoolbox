% This script is a first attempt to understand video tracking
% 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

%% load video

% clear all hidden;
% close all;
cfn = 0;

cdir    =   '/Users/jjheckman/Documents/Data/PhD/mouse/';
path    =   pb_getfile('dir',cdir);

if ~isempty(path); v = VideoReader(path); end

%%

figure(1);
currAxes = axes;

for i = 1:10:floor(v.Duration*v.FrameRate)
    vf = readFrame(v);
    image(vf,'Parent',currAxes)
    currAxes.Visible = 'off';
    input('Press return');
end

%%


while hasFrame(v)
vidFrame = readFrame(v);
image(vidFrame, 'Parent', currAxes);
currAxes.Visible = 'off';
pause(1/v.FrameRate);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

