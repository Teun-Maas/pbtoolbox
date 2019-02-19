% PB_ANALYSISSACLOC
%
% This script semi-automates your saccade localization analyses.
 
% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

%% INITIALIZE
%  Clear and ready workspace

pb_clean;
cfn  = pb_newfig(0);
axis([-60 60 -60 60]);
axis square
hold on;

%%

s = struct([]);

s(end+1).az = -20:10:20;
s(end+1).el = ones(1,length(s(end).az))*30;

s(end+1).az = -30:10:30;
s(end+1).el = ones(1,length(s(end).az))*20;

s(end+1).az = -40:10:40;
s(end+1).el = ones(1,length(s(end).az))*10;

s(end+1).az = -50:5:50;
s(end+1).el = zeros(1,length(s(end).az));

s(end+1).az = -40:10:40;
s(end+1).el = ones(1,length(s(end).az))*-10;


s(end+1).az = -30:10:30;
s(end+1).el = ones(1,length(s(end).az))*-20;

s(end+1).az = -20:10:20;
s(end+1).el = ones(1,length(s(end).az))*-30;


az = [];
el = [];

for i = 1:length(s)
   az = [az, s(i).az];
   el = [el, s(i).el];
end
scatter(az,el,'filled');
pb_hline;
pb_vline;

pb_nicegraph

%%

ind = 1:63;
ind1 = [1:2:5 6:2:12 13:2:21 23:2:42 44:2:50 53:2:57 60:2:62];
length(ind1)


az1 = az(ind1);
el1 = el(ind1);

% az1 = az(1:2:end);
% el1 = el(1:2:end);
% 
% az2 = az(2:2:end);
% el2 = el(2:2:end);

h(1)  = plot(az,el,'o');
h(2)  = plot(az1,el1,'o');

h(1).MarkerSize   = 12;
h(2).MarkerSize   = 12;

title('SLC setup Vestibulair Chair');
legend('RZ6a','RZ6b');
ylabel('Position (\epsilon)');
xlabel('Position (\alpha)');

pb_nicegraph


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

