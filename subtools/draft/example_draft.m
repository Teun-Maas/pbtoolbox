%% Initialize
%  Prepare example_draft: clean and initialize.

pb_clean;                  % Empty
load('exD_saccade');       % load example data
cfn = 0;                   % Initialize current figure number
run = 1;                   % Set # of blocks to run

%% Block 1:
%  Make figure 1: Plot data

% if run>cfn
%    %  Make figure & draft-obj
%    cfn   = pb_newfig(cfn,'size',[0 0 17 17],'resize','off'); 
%    d     = pb_draft('x',Saccades.GazeLatency,'y',Saccades.HeadLatency,'color',Saccades.Modality);
%    
%    %  Plots
%    d.plot_rawdata
%    d.plot_vline('type','mode');
%    d.plot_hline('type','mode');
%    
%    %  Layout
%    d.set_axcomp(Saccades.Subject);
%    d.set_title('Saccade Latencies');
%    d.set_labels('x','Gaze Latency (ms)','y','Head Latency (ms)');
%    d.set_grid;
%    d.set_legend('Entries',{'Audio','Visual','Audiovisual'});
%    
%    %  Build
%    d.draft
%    d.print('disp',true);
% end


%% Block 2:
%  Make figure 2: Plot rawdata + bubbleplot

if run>cfn
   %tic
   %  Make figure
   cfn = pb_newfig(cfn,'size',[0 0 17 11],'resize','off'); 
   for iR = 1:2
      %  Build draft-objs
      d(iR,1) = pb_draft('x',Saccades.GazeLatency,'y',Saccades.HeadLatency,'color',Saccades.Modality);

      %  Plots
      if ~iseven(iR)
         d(iR,1).plot_rawdata;
      else
         d(iR,1).plot_bubble;  
         d(iR,1).fit_ellipse;
      end
      d(iR,1).plot_dline;

      %  Axis Layout
      d(iR,1).set_labels('x','Gaze Latency (ms)','y','Head Latency (ms)');
   end

   %  Figure Layout
   d.set_title('Saccade Latencies');
   d.set_axcomp(Saccades.Subject);
   d.set_grid;
   d.set_legend('Entries',{'Audio','Visual','Audiovisual'});
   
   %  Build
   d.draft;
   %d.print('disp',true);
   %toc
end

%% Block 3:
%  Make figure 3: Probitplot

if run>cfn
   %  Make figure & draft-obj
   cfn   = pb_newfig(cfn,'size',[0 0 17 10],'resize','off');
   d     = pb_draft('y',Saccades.HeadLatency,'color',Saccades.Modality);
   
   d.stat_probit;
   
   d.set_axcomp(Saccades.Modality);
   d.set_title('Probit plot');
   d.set_labels('x','Reaction Times (ms)','y','Cumulative Probability');
   d.set_grid;
   
   %  Build
   d.draft;
   d.print('disp',true);
end


%% Block 4:
%  Make figure 4: Probitplot

if run>cfn
   %  Make figure & draft-obj
   cfn   = pb_newfig(cfn,'size',[0 0 17 10],'resize','off');
   d     = pb_draft('y',Saccades.HeadLatency,'color',Saccades.Modality);

   %  Build
   d.draft;
   d.print('disp',true);
end

