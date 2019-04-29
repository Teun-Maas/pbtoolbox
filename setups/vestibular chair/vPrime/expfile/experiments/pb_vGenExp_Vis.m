function pb_vGenExp_Vis(varargin)
% PB_VGENEXP_VIS()
%
% PB_VGENEXP_VIS()  will generate an EXP-file for a default localization experiment. 
% EXP-files are used for the psychophysical experiments at the
% Biophysics Department of the Donders Institute for Brain, Cognition and
% Behavior of the Radboud University Nijmegen, the Netherlands.
%
% VESTIBULAR STIMULATION PARAMETERS:
%
% Vestibular signals:      1) none, 
%                          2) predict sine, 
%                          3) noise, 
%                          4) turn, 
%                          5) VOR-turnstop.
%
% Azimuth rotation:        VER
% Elevation rotation:      HOR
%
% See also WRITESND, WRITELED, WRITETRG, GENWAV_DEFAULT, etc

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% Initialization
   %  Clear, empty, default imputs 

   pb_clean;
   disp('>> GENERATING VC EXPERIMENT <<');
   disp('   ...')

   cfn = 0;

   showexp     = pb_keyval('showexp',varargin,true);
   expfile     = pb_keyval('fname',varargin,'VOR.exp'); 
   datdir      = pb_keyval('datdir',varargin,'DEFAULT');
   cdir        = pb_keyval('cdir',varargin,userpath);
   
   cd(cdir);

   %% Desired azimuth and elevation
   %  Define hemisphere
   
   %  Select target ranges
   maxAbsAz       = 55;
   maxAbsEl       = 35;
   
   %  Possible targets
   dAz         = -50:05:50;
   dEl         = -30:10:30;
   [dAz,dEl]   = meshgrid(dAz,dEl);
   dAz         = dAz(:);
   dEl         = dEl(:);

   sel1			= (abs(dAz)+abs(dEl)) <= maxAbsAz & abs(dEl) <= maxAbsEl; 
   sel2        = iseven(dAz) | dEl == 0;
   sel         = sel1 & sel2;
   
   dAz         = dAz(sel);
   dEl         = dEl(sel);
   nloc        = numel(dAz);
   
   %% Select target positions
   %  Get targerts.
   
   targetInd   = randperm(length(dAz));
   dAz         = dAz(sort(targetInd(1:31)));
   dEl         = dEl(sort(targetInd(1:31)));

   %% Actual azimuth and elevation
   % The actual speaker positions are not perfectly aligned with 5 deg

   cfg			= pb_vLookup;                  % sphere positions
   channel		= cfg.interpolant(dAz',dEl');
   X           = cfg.lookup(channel+1,4);
   Y           = cfg.lookup(channel+1,5);

   %% Graphics

   if showexp
      cfn = pb_newfig(cfn);
      hold on;
      plot(dAz,dEl,'o')
      hold on
      plot(X,Y,'x')

      axis([-60 60 -60 60]);
      axis square
      set(gca,'TickDir','out');
      xlabel('Azimuth (deg)');
      ylabel('Elevation (deg)');
      pb_nicegraph;
   end

   %% Stimulus Condition
   
   % FIXATION LED
   fixled.bool    = true;    % do you want a fixation light?
   fixled.x       = 0;
   fixled.y       = 0;
   fixled.dur     = 1000;
   fixled.pause   = 1000;
   
   modality       = 2;        % 2=VISUAL
   int				= [50];     % w/ [i1, i2, i3...]
   dur            = [750];      % stim duration in ms
   col            = [1];      % w/ [R,G]
   
   [X,~,~]                 = ndgrid(X,0,col,int,dur);
   [Y,~,col,int,dur]       = ndgrid(Y,0,col,int,dur);
   
   X              = X(:);
   Y              = Y(:);
   int            = int(:);
   col            = col(:);
   dur            = dur(:);

   %% Number and size
   Sz				= size(X);
   N				= Sz(1); % number of trials
   
   maxtrialdur    = fixled.bool*(fixled.dur + fixled.pause) + max(dur);
   maxtrialdur    = ceil(maxtrialdur/500)/2;

   %% Vestibular blocks
   
   BD        = 60;                           % block duration in seconds
   bdureff         = BD-12;                  % start & stop
   trialsinblock  = bdureff / (maxtrialdur+1);    % trials per block
   BD             = ceil(N*(maxtrialdur+1)) + 12;
   
   blockconditions = [];
   nblockreps      = N/trialsinblock;

   block(1).Horizontal  = struct('Amplitude', 0,  'Signal', 1, 'Duration',  BD,   'Frequency',.1);
   block(1).Vertical    = struct('Amplitude', 0,  'Signal', 1, 'Duration',  BD,   'Frequency',.1);
   %% Save data somewhere
   writeexp(expfile,datdir,X,Y,int,dur,block,fixled); 
   % see below, these are helper functions to write an exp-file line by line / stimulus by stimulus

   %% Show the exp-file in Wordpad
   % for PCs
   if showexp
      if ispc
         dos(['"C:\Program Files\Windows NT\Accessories\wordpad.exe" ' expfile ' &']);
      elseif ismac
         system(['open -a TextWrangler ' cd filesep expfile]);
      end
   end
end

function writeexp(expfile,datdir,theta,phi,int,dur,block,fixled)
% Save known trial-configurations in exp-file
%
%  WRITEEXP WRITEEXP(FNAME,DATDIR,THETA,PHI,ID,LEDON)
%
%  WRITEEXP(FNAME,THETA,PHI,ID,LEDON)
%
%  Write exp-file with file-name FNAME.

   expfile		= fcheckext(expfile,'.exp');  % check whether the extension exp is included
   fid         = fopen(expfile,'wt+');         % this is the way to write date to a new file
   
   trialsz     = numel(theta);   	% number of trials
   blocksz     = length(block);     % xnumber of blocks
   trlIdx      = 1;                 % trial count
   
   ITI			= [0 0];    % useless, but required in header
   Rep			= 1;        % we have 0 repetitions, so insert 1...
   Rnd			= 0;        % we randomized ourselves already
   Mtr			= 'n';      % the motor should be on

   pb_vWriteHeader(fid,datdir,ITI,blocksz,blocksz*trialsz*Rep,Rep,Rnd,Mtr,'Lab',5); % helper-function
   
   for iBlock = 1:blocksz
      %  Write blocks
      
      pb_vWriteBlock(fid,iBlock);
      pb_vWriteSignal(fid,block(iBlock));
      
      %pl    = 1:trialsz;
      pl    = randperm(trialsz);       % randomize trialorder in blocks
      
      for iTrial = 1:trialsz
         %  Write trials
         
         pb_vWriteTrial(fid,trlIdx);
         VIS = [];
         
         VIS.LED        = 'LED'; 
         VIS.X          = theta(pl(iTrial)); 
         VIS.Y          = phi(pl(iTrial)); 
         VIS.Int        = int(pl(iTrial)); 
         VIS.EventOn    = 0; 
         VIS.Onset      = 500;
         VIS.EventOff   = 0; 
         VIS.Offset     = VIS.Onset + dur(pl(iTrial));
         
         VIS      = pb_vFixLed(VIS,fixled,'x',fixled.x,'y',fixled.y,'dur',fixled.dur,'pause',fixled.pause);
         trlIdx 	= trlIdx+1;
         
         pb_vWriteStim(fid,2,[],VIS);
      end
   end
   fclose(fid);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

