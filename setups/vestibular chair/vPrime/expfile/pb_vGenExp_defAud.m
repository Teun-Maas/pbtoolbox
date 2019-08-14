function pb_vGenexp_defAud
% PB_VGENEXP_DEFAUD()
%
% PB_VGENEXP_DEFAUD()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl


   %% 
   close all;
   clear hidden;
   disp('>> GENERATING EXPERIMENT <<');


   expfile     = 'defAud.exp'; % file name
   datdir      = 'DEFAULT';
   showexp = true ;
   
   %%
   
   %  Select target ranges
   maxAbsAz       = 55;
   maxAbsEl       = 35;

   %  Possible targets
   dAz         = -50:05:50;
   dEl         = -30:10:30;
   [dAz,dEl]   = meshgrid(dAz,dEl);
   dAz         = dAz(:);
   dEl         = dEl(:);

   sel1        = (abs(dAz)+abs(dEl)) <= maxAbsAz & abs(dEl) <= maxAbsEl; 
   sel2        = rem(abs(dAz),2)== 0| dEl == 0;
   sel         = sel1 & sel2;

   dAz         = dAz(sel);
   dEl         = dEl(sel);
   nloc        = numel(dAz);

   %% led 
   
   %fixled
   fixled.bool    = true;    % do you want a fixation light?
   fixled.x       = 0;
   fixled.y       = 0;
   fixled.dur     = 1000;
   fixled.pause   = 1000;
   
   %length sound 
   maxsnd = 200 ;
   minsnd = 200 ;
   dur    = [100];
   dur    = dur(:) ;

  
   %% Actual azimuth and elevation
   % The actual speaker positions are not perfectly aligned with 5 deg

   cfg			= pb_vLookup;                  % sphere positions
   channel		= cfg.interpolant(dAz',dEl');

   %%
   X           = cfg.lookup(channel+1,4);
   Y           = cfg.lookup(channel+1,5);
   
   %% plot graphics

   figure;
   hold on;
   plot(dAz,dEl,'.')
   hold on
   plot(X,Y,'.')

   axis([-60 60 -60 60]);
   axis square
   set(gca,'TickDir','out');
   xlabel('Azimuth (deg)');
   ylabel('Elevation (deg)');
   grid on;
 
   
   %% intensity and frequency 
   
   int         = [65]; % these DB intensities?
   snd			= [1]; % Only Broadband or more?
   [X,~,~]		= ndgrid(X,int,snd);
   [Y,int,snd]	= ndgrid(Y,int,snd);
   X				= X(:);
   Y				= Y(:);
   int			= int(:);
   snd			= snd(:);

   %% trails
   Sz				= size(X); 
   N				= Sz(1); %trails

   %%
   sndon       = 1250;
   sndon       = repmat(sndon,N,1); 
   sndon       = sndon(:);
   
   ledon       = 1000;
   ledon       = repmat (ledon,N,1); 
   ledon       = ledon(:);
   
   %% Randomize
   rnd			= randperm(N);
   X				= round(X(rnd));
   Y				= round(Y(rnd));
   
   %% vestiular block

   block(1).Horizontal  = struct('Signal', 1, 'Amplitude', 0, 'Duration',  0, 'Frequency', .1);
   block(1).Vertical    = struct('Signal', 1, 'Amplitude', 0, 'Duration',  0, 'Frequency', .1);
   
   %% Save data somewhere
   writeexp(expfile,datdir,X,Y,snd,int,ledon,sndon,dur,block)%,fixled); 
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

function writeexp(expfile,datdir,X,Y,snd,int,ledon,sndon,dur,block) 

% Save known trial-configurations in exp-file
%
%WRITEEXP WRITEEXP(FNAME,DATDIR,THETA,PHI,ID,INT,LEDON,SNDON)
%
% WRITEEXP(FNAME,THETA,PHI,ID,INT,LEDON,SNDON)
%
% Write exp-file with file-name FNAME.
%
%
% See also manual at neural-code.com

   expfile     = fcheckext(expfile,'.exp'); % check whether the extension exp is included


   fid         = fopen(expfile,'wt+'); % this is the way to write date to a new file
   ntrials     = numel(X); 
   blocksz     = length(block);
   
   %% Header of exp-file
   ITI         = [0 0];  % useless, but required in header
   Rep         = 1; % we have 0 repetitions, so insert 1...
   Rnd         = 0; % we randomized ourselves already
   Mtr         = 'n'; % the motor should be on
   pb_vWriteHeader(fid,datdir,ITI,blocksz,blocksz*ntrials*Rep,Rep,Rnd,Mtr,'Lab',5); % helper-function
 
   %% Body of exp-file
   % Create a trial

   for iBlock = 1:blocksz
      %  Write blocks

      pb_vWriteBlock(fid,iBlock);
      pb_vWriteSignal(fid,block(iBlock));
      for ii               = 1:ntrials        % each location
         writetrl(fid,ii);
         writeled(fid,'LED',0,0,5,0,0,0,ledon(ii)); % fixation LED
         pb_writesnd(fid,'SND',round(X(ii)),Y(ii),snd(ii),0,0,ledon(ii)+sndon(ii),ledon(ii)+sndon(ii)+dur); % Sound on
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

