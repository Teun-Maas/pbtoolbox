%% Example code 'draft'
pb_clean;
load('exD_saccade');

% construct
for i=1:3
   d(1,i) = pb_draft('x',Saccades.GazeLatency(Saccades.Subject==i)*1000,'y',Saccades.HeadLatency(Saccades.Subject==i)*1000,'color',Saccades.Modality(Saccades.Subject==i),'def',2,'subtitle',['s00' num2str(i)]);
   d(1,i).set_labels('x','Gaze Latency (ms)','y','Head Latency (ms)');
   %d(1,i).plot_dline
end

d.set_title('Saccade Latencies');
d.draft;
%d.print('disp',true);

% plotting order is wrong?