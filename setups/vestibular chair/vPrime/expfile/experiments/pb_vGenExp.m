function pb_vGenExp(varargin)
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

   clc;
   close all;
   clear hidden;
   disp('>> GENERATING VC EXPERIMENT <<');
   
   cfn = 0;
   
   showexp     = pb_keyval('showexp',varargin,true);
   expfile     = pb_keyval('fname',varargin,'default_vc.exp'); 
   datdir      = pb_keyval('datdir',varargin,'DEFAULT');
                                               
   %% Desired azimuth and elevation
   dAz         = -45:5:45;
   dEl         = 0;

   [dAz,dEl]   = meshgrid(dAz,dEl);
   dAz         = dAz(:);
   dEl         = dEl(:);

   sel			= (abs(dAz)+abs(dEl))<=60 & dEl>-45; 
   dAz         = dAz(sel);
   dEl         = dEl(sel);
   nloc        = numel(dAz);

   %% Actual azimuth and elevation
   % The actual speaker positions are not perfectly aligned with 5 deg

   cfg			= spherelookup; % sphere positions
   channel		= cfg.interpolant(dAz',dEl');
   X           = cfg.lookup(channel+1,5);
   Y           = cfg.lookup(channel+1,6);

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
   
   modality       = [2]; % [1 2 3]; w/ [A, V, AV]
   int				= 65; % approx. dB
   freq           = 1; % BB, HP, LP
   [X,~,~]			= ndgrid(X,0,freq);
   [Y,minled2off,freq]	= ndgrid(Y,0,freq);
   X              = X(:);
   Y              = Y(:);
   int				= int(:);
   freq           = freq(:);

   %% Number and size
   Sz				= size(X);
   N				= Sz(1);% number of trials

   %% Randomize sound samples (to simulate fresh noise
   snd				= freq;
   sel				= snd==1; % BB
   p				= transpose(randperm(100,sum(sel))-1);
   snd(sel)		= snd(sel)*100 + p;

   sel				= snd==2; % HP
   p				= transpose(randperm(100,sum(sel))-1);
   snd(sel)		= snd(sel)*100 + p;

   sel				= snd==3; % LP
   p				= transpose(randperm(100,sum(sel))-1);
   snd(sel)		= snd(sel)*100 + p;

   %% Blocks

   block(1).Horizontal = struct('Amplitude',15,'Signal',1,'Duration',60,'Frequency',.1);
   block(1).Vertical = struct('Amplitude',25,'Signal',2,'Duration',60,'Frequency',.1);
   block(2).Horizontal = struct('Amplitude',50,'Signal',2,'Duration',30,'Frequency',.1);
   block(2).Vertical = struct('Amplitude',15,'Signal',1,'Duration',60,'Frequency',.5);

   %% Save data somewhere
   writeexp(expfile,datdir,X,Y,snd,int,modality,block); 
   % see below, these are helper functions to write an exp-file line by line / stimulus by stimulus

   %% Show the exp-file in Wordpad
   % for PCs
   if ispc && showexp
       dos(['"C:\Program Files\Windows NT\Accessories\wordpad.exe" ' expfile ' &']);
   end
end

function writeexp(expfile,datdir,theta,phi,snd,int,modality,block)
% Save known trial-configurations in exp-file
%
%WRITEEXP WRITEEXP(FNAME,DATDIR,THETA,PHI,ID,LEDON)
%
% WRITEEXP(FNAME,THETA,PHI,ID,LEDON)
%
% Write exp-file with file-name FNAME.
%
%
% See also manual at neural-code.com

   expfile		= fcheckext(expfile,'.exp'); % check whether the extension exp is included


   fid         = fopen(expfile,'w'); % this is the way to write date to a new file
   ntrials     = numel(theta); % only 135 trials

   %% Header of exp-file
   ITI			= [0 0];  % useless, but required in header
   Rep			= 1; % we have 0 repetitions, so insert 1...
   Rnd			= 0; % we randomized ourselves already
   Mtr			= 'n'; % the motor should be on
   writeheader(fid,datdir,ITI,ntrials*Rep,Rep,Rnd,Mtr,'Lab',2); % helper-function

   fprintf(fid,'\n%s%s\t%s\t%s\t%s\t%s','%','AX','SIG','AMP','DUR','FREQ');
   fprintf(fid,'\n%s\t\t\t%s\t%s\t%s\t%s\t%s\t%s\n','%','edg','bit','Event','Time','Event','Time');

   %% Body of exp-file
   % Create a trial
   
   for ii               = 1:ntrials		% each location
        
        AUD.SND = 'SND'; 
        AUD.X = theta; 
        AUD.Y = phi; 
        AUD.ID = snd(ii); 
        AUD.Int = int(ii); 
        AUD.EventOn = 1; 
%        AUD.Onset = ledon(ii)+sndon(ii);
        
        VIS.LED = 'LED'; 
        VIS.X = theta; 
        VIS.Y = phi; 
        VIS.Int = 5; 
        VIS.EventOn = 1; 
%        VIS.Onset = ledon(ii)+sndon(ii); 
        VIS.EventOff = 1; 
%        VIS.Offset = ledon(ii)+sndon(ii)+dur(ii);
        
        writetrl(fid,ii);
%        writeled(fid,'LED',0,0,5,0,0,1,ledon(ii)); % fixation LED
%        pb_writestim(modality(ii),fid,AUD,VIS);
    end
    fclose(fid);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

