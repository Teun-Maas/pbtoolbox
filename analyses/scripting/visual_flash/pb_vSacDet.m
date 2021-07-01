%% Initialize
%  Clean, get directory, and load data

cfn   = pb_clean('cd','/Users/jjheckman/Desktop/PhD/Data/Chapter 3/subj');
path  = pb_getdir('cdir',cd);
cd(path)

%  Load data
l     = dir('preprocessed_*.mat');

if isempty(l); return; end
fn    = l(1).name;
load(fn);

%  Switch to sacdet folder
path  = [path filesep 'sacdet'];
cd(path)

%%	Run sacdet over epoched data
%  Read converted data file, preprocess all blocks, and store data

l     = dir('*.sac');
if ~isempty(l); return; end


%% Make hv & csv and run sacdet


Dlen        = length(Data.epoch);
fs          = 120;
duration    = 3;
samples     = duration * fs;

for iB = 1:Dlen

   % Saving calibrated data
   fname                   = fcheckext(['sacdet_' fn(14:end-5) '_block_' num2str(iB,'%03.f') '_azel'] ,'.hv');
   fid                     = fopen([path filesep fname],'w','l');
   AZEL                    = [Data.epoch(iB).AzGazeEpoched; Data.epoch(iB).ElGazeEpoched];
   
   fwrite(fid,AZEL,'float');
   fclose(fid);
   
   fn_csv = [path filesep fname];
   VC2csv(fn_csv,fs,samples,1:length(Data.epoch(iB).AzGazeEpoched)/samples);
   
   if ~isfile(fn_csv(1:end-3)) == 1
       pa_sacdet;
       pause;
   end
end


%% Save saccades
%  check saccades 


l = dir('sacdet_JJH-0001-21-06-0_block_*.hv');

clear Sac Stim
for iL = 1:length(l)
   fn    = l(iL).name(1:end-3);
   pa_sac2mat([fn '.hv'],[fn '.csv'],[fn '.sac']);
   
   % Take only first saccades
   load(fn,'-mat');
   Sac   = Sac(Sac(:,2) == 1,:);
   save(fn, 'Sac', 'Stim');
end
