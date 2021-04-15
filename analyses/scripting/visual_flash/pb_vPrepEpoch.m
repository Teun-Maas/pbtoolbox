%% Initialize
%  Clean, get directory, and load data

cfn   = pb_clean('cd','/Users/jjheckman/Desktop/PhD/Data/Chapter 3/subj');
path  = pb_getdir('cdir',cd);
cd(path)

%%  Preprocess converted data
%  Read converted data file, preprocess all blocks, and store data

l     = dir('converted*.mat');
fn    = l(1).name;  

l     = dir('prep*.mat');
if isempty(l)
   Data  = pb_vPrepData('fn',fn,'path',path,'block','all','stim',1,'store',1);
else 
   load(l(1).name)
end

l     = dir('prep*.mat');
fn    = l(1).name;

%% Epoch data and sacdet
%  Epoching to only take relevant parts of data

fs          = 120;
duration    = 3;
samples     = fs*duration - 1;

for iB = 1:length(Data.timestamps)
   
   % Empty traces
   E.AzChairEpoched   	= [];
   E.ElChairEpoched    = [];
   E.AzGazeEpoched     = [];
   E.ElGazeEpoched     = [];
   E.AzEyeEpoched      = [];
   E.ElEyeEpoched      = [];
   E.AzHeadEpoched     = [];
   E.ElHeadEpoched     = [];
   
   % Interpolate Gaze
   lsl_opti  	= Data.timestamps(iB).optitrack;
   Data.timestamps(iB).epoch_interp       = 0:1/120:lsl_opti(end)-lsl_opti(1);
   Data.position(iB).gaze_interp(:,1)     = interp1(lsl_opti-lsl_opti(iB), Data.position(iB).gaze(:,1), Data.timestamps(iB).epoch_interp,'pchip')';
   Data.position(iB).gaze_interp(:,2)  	= interp1(lsl_opti-lsl_opti(iB), Data.position(iB).gaze(:,2), Data.timestamps(iB).epoch_interp,'pchip')';
   
   % Interpolate Chair
   CUT_OFF = 203;
   Data.position(iB).chair_interp(:,1)    = interp1(Data.timestamps(iB).chair, Data.position(iB).chair, Data.timestamps(iB).epoch_interp,'pchip')';
   Data.position(iB).chair_interp(Data.timestamps(iB).epoch_interp>CUT_OFF,1)  = zeros(1,sum(Data.timestamps(iB).epoch_interp>CUT_OFF));              % Correct for extrapolation == 0;
   Data.position(iB).chair_interp(:,2)    = zeros(size(Data.position(iB).chair_interp(:,1)));
   
   % Interpolate Eye
   Data.position(iB).eye_interp(:,1)      = interp1(lsl_opti-lsl_opti(iB), Data.position(iB).pupillabs(:,1), Data.timestamps(iB).epoch_interp,'pchip')';
   Data.position(iB).eye_interp(:,2)      = interp1(lsl_opti-lsl_opti(iB), Data.position(iB).pupillabs(:,2), Data.timestamps(iB).epoch_interp,'pchip')';
   
   % Interpolate Head
   Data.position(iB).head_interp(:,1)      = interp1(lsl_opti-lsl_opti(iB), Data.position(iB).optitrack(:,1), Data.timestamps(iB).epoch_interp,'pchip')';
   Data.position(iB).head_interp(:,2)      = interp1(lsl_opti-lsl_opti(iB), Data.position(iB).optitrack(:,2), Data.timestamps(iB).epoch_interp,'pchip')';
   
   
   % Select stimuli indices
   nstim       = length(Data.stimuli(iB).azimuth);
   ntriggers   = length(Data.timestamps(iB).stimuli);
   ind         = 1;
   ext         = 2;

   for iS = 1:nstim
      % epoch for stimuli
      start             = Data.timestamps(iB).stimuli(ind) - lsl_opti(1);
      [~,idx]           = min(abs(Data.timestamps(iB).epoch_interp-start));
      
      % Gaze
      E.AzGazeEpoched  	= [E.AzGazeEpoched, Data.position(iB).gaze_interp(idx:idx+samples,1)'];
      E.ElGazeEpoched  	= [E.ElGazeEpoched, Data.position(iB).gaze_interp(idx:idx+samples,2)'];
      
      % Chair
      E.AzChairEpoched  = [E.AzChairEpoched, Data.position(iB).chair_interp(idx:idx+samples,1)'];
      E.ElChairEpoched 	= [E.ElChairEpoched, Data.position(iB).chair_interp(idx:idx+samples,2)'];
      
      % Eye
      E.AzEyeEpoched   	= [E.AzEyeEpoched, Data.position(iB).eye_interp(idx:idx+samples,1)'];
      E.ElEyeEpoched   	= [E.ElEyeEpoched, Data.position(iB).eye_interp(idx:idx+samples,2)'];

      % Head
      E.AzHeadEpoched   = [E.AzHeadEpoched, Data.position(iB).head_interp(idx:idx+samples,1)'];
      E.ElHeadEpoched   = [E.ElHeadEpoched, Data.position(iB).head_interp(idx:idx+samples,2)'];
      
      ind = ind + ext;
   end
   Data.epoch(iB) = E;
end


fn = strrep(fn,'preprocessed','epoched');
save(fn,'Data');


