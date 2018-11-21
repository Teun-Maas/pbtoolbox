function pb_vGenVisExp(varargin)
% PB_VGENEXP()
%
% PB_VGENEXP() will generate an EXP-file for a default localization experiment. 
% EXP-files are used for the psychophysical experiments at the
% Biophysics Department of the Donders Institute for Brain, Cognition and
% Behavior of the Radboud University Nijmegen, the Netherlands.
%
% See also ... See also WRITESND, WRITELED, WRITETRG, GENWAV_DEFAULT, etc

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% Initialization
   %  Clear, empty, default imputs 

   pb_clean;
   disp('>> GENERATING VC EXPERIMENT <<');
   disp('   ...')

   cfn = 0;

   showexp     = pb_keyval('showexp',varargin,true);
   expfile     = pb_keyval('fname',varargin,'default_vc.exp'); 
   datdir      = pb_keyval('datdir',varargin,'DEFAULT');
   cdir        = pb_keyval('cdir',varargin,userpath);
   
   cd(cdir);

   %% Desired azimuth and elevation
   
   %  Select target ranges
   maxAbsAz       = 45;
   maxAbsEl       = 0;
   
   %  Possible targets
   dAz         = -45:5:45;
   dEl         = 0;
   [dAz,dEl]   = meshgrid(dAz,dEl);
   dAz         = dAz(:);
   dEl         = dEl(:);

   sel			= (abs(dAz)+abs(dEl)) <= maxAbsAz & abs(dEl) <= maxAbsEl; 
   dAz         = dAz(sel);
   dEl         = dEl(sel);
   nloc        = numel(dAz);

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

      axis([-50 50 -50 50]);
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
   fixled.dur     = 2000;
   
   modality       = 2;        % 2=VISUAL
   int				= [50];     % w/ [i1, i2, i3...]
   dur            = [1];    % stim duration in ms
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

   %% Block Information

   block(1).Horizontal  = struct('Amplitude',15,'Signal',1,'Duration',60,'Frequency',.1);
   block(1).Vertical    = struct('Amplitude',25,'Signal',2,'Duration',60,'Frequency',.1);
   block(2).Horizontal  = struct('Amplitude',50,'Signal',2,'Duration',30,'Frequency',.1);
   block(2).Vertical    = struct('Amplitude',15,'Signal',1,'Duration',60,'Frequency',.1);

   %% Save data somewhere
   writeexp(expfile,datdir,X,Y,int,dur,block,fixled); 
   % see below, these are helper functions to write an exp-file line by line / stimulus by stimulus

   %% Show the exp-file in Wordpad
   % for PCs
   if ispc && showexp
      dos(['"C:\Program Files\Windows NT\Accessories\wordpad.exe" ' expfile ' &']);
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
   fid         = fopen(expfile,'w');         % this is the way to write date to a new file
   
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
      
      pl    = 1:trialsz;
      %pl    = randperm(trialsz);       % randomize trialorder in blocks
      
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
         
         VIS      = pb_vFixLed(VIS,fixled,'x',fixled.x,'y',fixled.y,'dur',fixled.dur);
         trlIdx 	= trlIdx+1;
         
         pb_vWriteStim(fid,2,[],VIS);
      end
   end
   fclose(fid);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

