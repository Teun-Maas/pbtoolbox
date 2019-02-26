%% Initialize
%  Prepare example_draft: clean and initialize.

pb_clean;                  % Empty
load('exD_saccade');       % load example data
cfn = 0;                   % Initialize current figure number
run = 2;                   % Set # of blocks to run

%% Block1:
%  Make figure 1: Plot rawdata + bubbleplot

if run>cfn
   cfn = pb_newfig(cfn,'size',[0 0 17 12],'resize','off'); 
   for i = 1:1
      for j = 1:2
         d(j,i) = pb_draft('x',Saccades.GazeLatency,'y',Saccades.HeadLatency,'color',Saccades.Modality);
         d(j,i).set_labels('x','Gaze Latency (ms)','y','Head Latency (ms)');
         if ~iseven(i*j)
            d(j,i).plot_rawdata;
         else
            d(j,i).plot_bubble;  
            d(j,i).fit_ellipse;
         end
         d(j,i).plot_dline;
         d(j,i).plot_vline('type','mode');
         d(j,i).plot_hline('type','mode');
      end
   end

   d.set_title('Saccade Latencies');
   d.set_axcomp(Saccades.Subject);
   d.set_grid;
   d.draft;
   d.print('disp',true);
end

%% Block2:
%  Make figure 2: Plot rawdata + bubbleplot

if run>cfn
   cfn   = pb_newfig(cfn,'size',[0 0 17 17],'resize','off'); 
   d     = pb_draft('x',Saccades.GazeLatency,'y',Saccades.HeadLatency,'color',Saccades.Modality);
end


%% Block3:

if run>cfn
   cfn   = pb_newfig(cfn,'size',[0 0 17 17],'resize','off'); 
   d     = pb_draft('x',Saccades.GazeLatency,'y',Saccades.HeadLatency,'color',Saccades.Modality);
end