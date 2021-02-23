%% Initialize
%  Clean and get directory

cfn   = pb_clean('cd','/Users/jjheckman/Library/Mobile Documents/com~apple~CloudDocs/PhD/Data/Chapter 3/subj');
path  = pb_getdir('cdir',cd);


%% Convert data
%  Convert or load converted data

%  load data
l     = dir([path filesep 'convert*.mat']);
if isempty(l)
   fn = pb_zipblocks(path);
else 
   fn = l(1).name;                                                            % if converted data already exists, just read fn
end

%  preprocess data
l = dir([path filesep 'preprocessed*.mat']);
if isempty(l)
   Data  = pb_vPrepData('fn',fn,'path',path,'stim',1,'store',1);              % preprocess data (LSL sync, get traces, compute gaze) %% CHECK BLOCK LENGTH!! ALSO, STIMULI, AND VC MATCH VOR?
else
   load([path filesep l(1).name]);
end

Data  = pb_vPrepData('fn',fn,'path',path,'stim',1,'store',1);

return

%% Graph difference between new and old method
%  Old method includes different translation of the head, new method
%  doesn't. Note that New method seems to drift away from 0. But differense
%  is general is minute.

for iB = 1:length(Data.position)
   % Blocks
   
   cfn   = pb_newfig(cfn);
   sgtitle(['Gaze reconstruction (block ' num2str(iB) ')']);
   cO    = {'Azimuth','Elevation'};

   for iO = 1:2
      % Orientation

      % statistics
      old   = Data.position(iB).gaze(:,iO);
      new   = Data.position(iB).gaze_n(:,iO);
      mu    = mean(old - new);
      err   = std(old - new);

      % Graph
      subplot(1,2,iO);
      title([cO{iO} ' ($\mu \Delta ' num2str(mu,2) ' \pm ' num2str(err,2) '$)'])
      hold on;
      axis square;
      plot(Data.timestamps(iB).optitrack-Data.timestamps(iB).optitrack(1), old);
      plot(Data.timestamps(iB).optitrack-Data.timestamps(iB).optitrack(1), new);
      ylim([-50 50]);
      xlabel('Time ($s$)');
      ylabel('Position ($^{\circ}$)');
      legend('Old method','New method');
   end
   linkaxes(pb_fobj(gcf,'type','axes'),'x')
   pb_nicegraph('def',2);
end


%% Graph gaze reconstruction
%  This part shows you the difference for head fixed and free condition in
%  gaze reconstruction (old method)

for iB = 1:length(Data.position)
   % Check different conditions
   cfn = pb_newfig(cfn);
   sgtitle(['Example reconstruction (block ' num2str(iB) ')']);

   for iO = 1:2
      % Orientation
      subplot(1,2,iO)
      title(cO{iO});
      hold on;
      axis square;

      plot(Data.timestamps(iB).optitrack - Data.timestamps(iB).optitrack(1), Data.position(iB).optitrack(:,iO));
      plot(Data.timestamps(iB).optitrack - Data.timestamps(iB).optitrack(1), Data.position(iB).pupillabs(:,iO));
      plot(Data.timestamps(iB).optitrack - Data.timestamps(iB).optitrack(1), Data.position(iB).gaze(:,iO));

      stim_orient = Data.stimuli(iB).azimuth;
      if iO > 1; stim_orient = Data.stimuli(iB).elevation; end

      % plot targets
      t = Data.timestamps(iB).stimuli - Data.timestamps(iB).optitrack(1);
      plot(t(1:2:end-1),stim_orient,'Marker','*','linestyle','none','Tag','Fixed','color',[0 0 0]);


      xlim([80 90]);
      ylim([-50 50])
      xlabel('Time ($s$)');
      ylabel('Position ($^{\circ}$)');
      legend('Head','Eye','Gaze');
   end
   linkaxes(pb_fobj(gcf,'type','axes'),'x')
   pb_nicegraph;
end


%% Epoch data
% Epoching to only take relevant parts of data

fs          = 120;
duration    = 2;
samples     = fs*duration -1;

for iB = 1:length(Data.timestamps)
   lsl_opti                            = Data.timestamps(iB).optitrack;
   Data.timestamps(iB).gaze_interp      = 0:1/120:lsl_opti(end)-lsl_opti(1);

   Data.position(iB).gaze_interp(:,1)     = interp1(lsl_opti-lsl_opti(iB), Data.position(iB).gaze(:,1), Data.timestamps(iB).gaze_interp,'pchip')';
   Data.position(iB).gaze_interp(:,2)  	= interp1(lsl_opti-lsl_opti(iB), Data.position(iB).gaze(:,2), Data.timestamps(iB).gaze_interp,'pchip')';

   % Epoching
   % Only take relevant parts of data

   AzGazeEpoched = [];
   ElGazeEpoched = [];

   nstim       = length(Data.stimuli(iB).azimuth);
   ntriggers   = length(Data.timestamps(iB).stimuli);
   ind         = 2;
   ext         = ntriggers/nstim;

   for iS = 1:nstim
       start            = Data.timestamps(iB).stimuli(ind) - lsl_opti(1);
       [~,idx]          = min(abs(Data.timestamps(iB).gaze_interp-start));
       AzGazeEpoched    = [AzGazeEpoched, Data.position(iB).gaze_interp(idx:idx+359,1)'];
       ElGazeEpoched    = [ElGazeEpoched, Data.position(iB).gaze_interp(idx:idx+359,2)'];
       ind=ind+ext;
   end

   % Saving calibrated data
   fname                   = fcheckext([fn(16:end-4) '_block_' num2str(iB)] ,'AzElGazeAB.hv');
   fid                     = fopen([path filesep fname],'w','l');
   AZEL                    = [AzGazeEpoched; ElGazeEpoched];
   fwrite(fid,AZEL,'float');
   fclose(fid);

   % Create csv file
   VC2csv([path filesep fname 'AzElGazeAB'],120,360,1:nstim);

   %% Check if saccade identification is needed
   disp('SacDet TIME!')

   if isfile([fn '_block_' num2str(iB) '.AzElGazeAB.sac']) == 1
       pa_sac2mat();
   else
       pa_sacdet();
       pause 
       pa_sac2mat(); 
   end
end

%% Plot data

l = dir([path filesep fname(1:20) '*.AzElGazeAB']);
for iB = 1:length(l)
   % repeat for blocks
   
   clear ResultAz ResultEl SacD ReturnAz ReturnEl StartAz StartEl
   load([path filesep l(iB).name],'-mat');
   
   for iS = 1:length(Data.stimuli(iB).azimuth)
      % check if stimuli have response
       ind = find(Sac(:,1) == iS);
       if isempty(ind)
           ResultAz(iS)    = NaN;
           ResultEl(iS)    = NaN;
           SacDur(iS)      = NaN;
           ReturnAz(iS)    = NaN;
           ReturnEl(iS)    = NaN;
           StartAz(iS)     = NaN;
           StartEl(iS)     = NaN;
       else
           ResultAz(iS)    = Sac(ind(end),8);
           ResultEl(iS)    = Sac(ind(end),9);
           StartAz(iS)     = Sac(ind(1),6);
           StartEl(iS)     = Sac(ind(1),7);
           SacDur(iS)      = Sac(ind(1),14);
       end
   end
   
   % plot
   cfn = pb_newfig(cfn);
   sgtitle(l(iB).name)

   subplot(1,3,1)
   title('Targets')
   hold on;
   axis square;
   plot(ResultAz, ResultEl,'o')
   axis([-50 50 -50 50])
   pb_dline;
   xlabel('Azimuth ($^{\circ}$)')
   ylabel('Elevation ($^{\circ}$)')

   subplot(1,3,2)
   title('Azimuth')
   hold on;
   axis square;
   plot(Data.stimuli(iB).azimuth, ResultAz,'o')
   axis([-50 50 -50 50])
   pb_dline;
   xlabel('Target ($^{\circ}$)')
   ylabel('Response ($^{\circ}$)')

   subplot(1,3,3)
   title('Elevation')
   hold on;
   axis square;
   plot(Data.stimuli(iB).elevation, ResultEl,'o')
   axis([-50 50 -50 50])
   pb_dline;
   xlabel('Target ($^{\circ}$)')
   ylabel('Response ($^{\circ}$)')

   pb_nicegraph;
end

