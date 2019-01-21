function pb_vVORExp(varargin)
% PB_VGENVISEXP
%
% PB_VGENVISEXP(varargin) will generate an EXP-file for a default localization experiment. 
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

   %% Vestibular blocks
   
   BD        = 60;                           % block duration in seconds
   
   %% Sine
   block(1).Horizontal  = struct('Amplitude', 0,  'Signal', 2, 'Duration',  BD,   'Frequency',.1);
   block(1).Vertical    = struct('Amplitude', 13, 'Signal', 2, 'Duration',  BD,   'Frequency',.3);
   
   block(2).Horizontal  = struct('Amplitude', 0,  'Signal', 2, 'Duration',  BD,   'Frequency',.0);
   block(2).Vertical    = struct('Amplitude', 20, 'Signal', 2, 'Duration',  BD,   'Frequency',.2);
   
   block(3).Horizontal  = struct('Amplitude', 0,  'Signal', 2, 'Duration',  BD,   'Frequency',.1);
   block(3).Vertical    = struct('Amplitude', 40, 'Signal', 2, 'Duration',  BD,   'Frequency',.1);
   
   %% Turnstop
   block(4).Horizontal  = struct('Amplitude', 0,  'Signal', 5, 'Duration',  BD,   'Frequency',.1);
   block(4).Vertical    = struct('Amplitude', 20, 'Signal', 5, 'Duration',  BD,   'Frequency',.1);

   block(5).Horizontal  = struct('Amplitude', 0,  'Signal', 5, 'Duration',  BD,   'Frequency',.1);
   block(5).Vertical    = struct('Amplitude', 30, 'Signal', 5, 'Duration',  BD,   'Frequency',.1);
   
   block(6).Horizontal  = struct('Amplitude', 0,  'Signal', 5, 'Duration',  BD,   'Frequency',.1);
   block(6).Vertical    = struct('Amplitude', 40, 'Signal', 5, 'Duration',  BD,   'Frequency',.1);
   
   block(7).Horizontal  = struct('Amplitude', 0,  'Signal', 5, 'Duration',  BD,   'Frequency',.1);
   block(7).Vertical    = struct('Amplitude', 50, 'Signal', 5, 'Duration',  BD,   'Frequency',.1);
   
   %% Noise
   
   block(8).Horizontal  = struct('Amplitude', 0,  'Signal', 3, 'Duration',  BD,   'Frequency',.1);
   block(8).Vertical    = struct('Amplitude', 20, 'Signal', 3, 'Duration',  BD,   'Frequency',.1);   

   block(9).Horizontal  = struct('Amplitude', 0,  'Signal', 3, 'Duration',  BD,   'Frequency',.1);
   block(9).Vertical    = struct('Amplitude', 30, 'Signal', 3, 'Duration',  BD,   'Frequency',.1);
   
   block(10).Horizontal  = struct('Amplitude', 0,  'Signal', 5, 'Duration',  BD,   'Frequency',.1);
   block(10).Vertical    = struct('Amplitude', 40, 'Signal', 5, 'Duration',  BD,   'Frequency',.1);

   %% Save data somewhere
   writeexp(expfile,datdir,block); 
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

function writeexp(expfile,datdir,block)
% Save known trial-configurations in exp-file
%
%  WRITEEXP WRITEEXP(FNAME,DATDIR,THETA,PHI,ID,LEDON)
%
%  WRITEEXP(FNAME,THETA,PHI,ID,LEDON)
%
%  Write exp-file with file-name FNAME.

   expfile		= fcheckext(expfile,'.exp');  % check whether the extension exp is included
   fid         = fopen(expfile,'wt+');         % this is the way to write date to a new file
   
   blocksz     = length(block);     % xnumber of blocks
   
   ITI			= [0 0];    % useless, but required in header
   Rep			= 1;        % we have 0 repetitions, so insert 1...
   Rnd			= 0;        % we randomized ourselves already
   Mtr			= 'n';      % the motor should be on

   pb_vWriteHeader(fid,datdir,ITI,blocksz,0,Rep,Rnd,Mtr,'Lab',5); % helper-function
   
   for iBlock = 1:blocksz
      %  Write blocks
      
      pb_vWriteBlock(fid,iBlock);
      pb_vWriteSignal(fid,block(iBlock));
   end
   fclose(fid);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

