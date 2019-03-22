%% Initialize
%  Prepare example_draft: clean and initialize.

pb_clean;                  % Empty
load('exD_saccade');       % load example data
cfn = 0;                   % Initialize current figure number

%% Block 1:
%  Make figure 1: Plot data


%  Build draft-objs
d(1) = pb_draft('x',Saccades.GazeLatency,'y',Saccades.HeadLatency,'color',Saccades.Modality);
d(2) = pb_draft('x',Saccades.GazeLatency,'y',Saccades.HeadLatency,'color',Saccades.Modality);
d(3) = pb_draft('x',Saccades.GazeLatency,'y',Saccades.HeadLatency,'color',Saccades.Modality);

%  Figure Layout
d.set_title('Saccade Latencies');
d.set_grid;
d.set_legend('Entries',{'Audio','Visual','Audiovisual'});

%  Build
d.draft;
