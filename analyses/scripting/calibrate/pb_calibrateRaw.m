% PB_CALIBRATERAW
%
% This script semi-automates your .... analyses.
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

%% Locate Dir

% clear all hidden;
% close all;
cfn = 0;

cdir    =   '/Users/jjheckman/Documents/Data/PhD/';
path   =   pb_getdir('dir',cdir);

if ~isempty(path); cd(path); end

%% horziontal, vertical, and frontal channel

cfn=cfn+1;figure(cfn);clf;

hor = []; ver = []; fron = [];

for i = 1:24
    
    str = ['JJH-0001-18-04-04-0000-' sprintf('%04d',i) '.sphere'];
    load(str, '-mat');
    
    subplot(131)
    hold on; axis([0 25 -10 10])
    %plot(data.raw(:,1))
    hor(i) = mean(data.raw(:,1));
    cla; hh = plot(hor,'*-');
    
    subplot(132)
    hold on; axis([0 25 -10 10])
    %plot(data.raw(:,2))
    ver(i) = mean(data.raw(:,2));
    cla; hv = plot(ver,'*-');
    
    subplot(133)
    hold on; axis([0 25 -10 10])
    %plot(data.raw(:,3))
    fron(i) = mean(data.raw(:,3));
    cla; hf = plot(fron,'*-');
    
    pb_nicegraph;


end

col = pb_selectcolor(3,2);

for j = 1:3
    subplot(1,3,j)
    h = findobj(gca,'Type','Line')
    set(h,'Color',col(j,:))
end


cfn=cfn+1; figure(cfn);clf;
hold on; axis([0 25 -10 10])
plot(hor,'*-');
plot(ver,'*-');
plot(fron,'*-');

[~,lct] = findpeaks(abs(fron));
pb_vline(lct);
pb_nicegraph;
legend('Horizontal','Vertical','Frontal')

%% Load trails 

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
