%% Example code 'draft'
pb_clean;
load('exD_saccade');

cfn = pb_newfig(0,'size',[0 0 17 17],'resize','off'); 

%%

% construct
for i = 1:2
   for j = 1:2
      d(j,i) = pb_draft('x',Saccades.GazeLatency*1000,'y',Saccades.HeadLatency*1000,'color',Saccades.Modality,'subtitle',['s00' num2str(j)]);
      d(j,i).set_labels('x','Gaze Latency (ms)','y','Head Latency (ms)');
      if ~iseven(j)
         d(j,i).plot_rawdata;
      else
         d(j,i).plot_bubble;  
         d(j,i).fit_ellipse;
      end
      %d(j,i).fit_ellipse;
      d(j,i).plot_dline;
      d(j,i).plot_vline('type','mode');
      d(j,i).plot_hline('type','mode');
   end
end

d.set_title('Saccade Latencies');
d.draft;
d.print('disp',true);
