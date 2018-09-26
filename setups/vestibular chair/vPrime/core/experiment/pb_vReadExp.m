function [block,cfg] = pb_vReadExp(cfg)
% PB_VREADEXP(expfile)
%
% PB_VREADEXP() reads experimental data from expfile and loads BLOCK and
% CFG parameters.
%
% See also PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% INITIALIZE
   
   expfile = cfg.expfname;
   if ~pb_fexist(expfile); return; end
   fid = fopen(expfile,'r');
   
   %% HEADER
   
   cfg.comment = checkcomment(fid);
   cfg         = hread(fid,cfg);
   n           = cfg.Blocks;
   
   %% EXP
   
   block      = struct([]);
   block(1).signal                     = [];
   block(1).trial                      = [];

   bn = 0;
   while ~feof(fid)
      tline       = fgetl(fid);
      firstCell   = sscanf(tline,'%s',1);
      nchar				= length(firstCell);
      if strcmp(firstCell,'%'); firstCell = sscanf(tline,'%s',2); firstCell = firstCell(2:end-1); end

      switch upper(firstCell)
         case 'BLOCK'
            % Updates counts for block
            bn = bn+1; tn = 0; sn = 0;
            fgetl(fid); 
         
         case 'TRIAL'
            % Updates counts for trial
            tn = tn+1; sn = 0;
            
         case 'HOR'
            % Writes horizontal vestibular signal for block
            block(bn).signal.hor = readVest(tline); 
            
         case 'VER'
            % Writes vertical vestibular signal for block
            block(bn).signal.ver = readVest(tline); 
            
         case {'SND','SND1','SND2'}
            % Updates count and writes stimulus
            sn    = sn+1;
            par   = sscanf(tline(nchar+1:end),'%d%d%d%f%d%d',[6,1]);
            
            block(bn).trial(tn).stim(sn).modality		= 'sound';
            block(bn).trial(tn).stim(sn).X            = par(1);
            block(bn).trial(tn).stim(sn).Y            = par(2);
            block(bn).trial(tn).stim(sn).matfile		= ['snd' num2str(par(3),'%03i') '.mat']; % for sphere
            block(bn).trial(tn).stim(sn).wavfile		= ['snd' num2str(par(3),'%03i') '.wav']; % double, for hoop
            block(bn).trial(tn).stim(sn).parameters	= par(3); % for sphereMinor

            block(bn).trial(tn).stim(sn).matfile		= ['snd' num2str(par(3),'%03i') '.mat'];
            block(bn).trial(tn).stim(sn).wavfile		= ['snd' num2str(par(3),'%03i') '.wav'];	 % double

            block(bn).trial(tn).stim(sn).intensity    = par(4);
            block(bn).trial(tn).stim(sn).onevent		= par(5);
            block(bn).trial(tn).stim(sn).ondelay		= par(6);
            block(bn).trial(tn).stim(sn).offevent		= par(5); % default duration
            block(bn).trial(tn).stim(sn).offdelay		= par(6)+150; % default duration
            
         case {'LED','LED1','LED2'}
            % Updates count and writes stimulus
            sn    = sn+1;
            par   = sscanf(tline(nchar+1:end),'%d%d%d%d%d%d%d',[7,1]);
				
            block(bn).trial(tn).stim(sn).modality		= 'LED';
				block(bn).trial(tn).stim(sn).X            = par(1);
				block(bn).trial(tn).stim(sn).Y            = par(2);

				block(bn).trial(tn).stim(sn).intensity    = par(3);

				block(bn).trial(tn).stim(sn).intensity    = par(3);  % hoop: range 0-255, sphere range 1-50

				block(bn).trial(tn).stim(sn).onevent		= par(4);
				block(bn).trial(tn).stim(sn).ondelay		= par(5);
				block(bn).trial(tn).stim(sn).offevent		= par(6);
				block(bn).trial(tn).stim(sn).offdelay		= par(7);

            
         case 'TRG0'
            % Updates count and writes stimulus
            sn    = sn+1;
            par	= sscanf(tline(nchar+1:end),'%d%d%d%d%d',[5,1]);
            
            block(bn).trial(tn).stim(sn).modality		= 'trigger';
            if par(1) == 1
               block(bn).trial(tn).stim(sn).detect		= 'rise';
            elseif par==2
               block(bn).trial(tn).stim(sn).detect		= 'fall';
            end
            block(bn).trial(tn).stim(sn).channel		= par(2);
            block(bn).trial(tn).stim(sn).onevent		= par(3);
            block(bn).trial(tn).stim(sn).ondelay		= par(4);
            block(bn).trial(tn).stim(sn).event        = par(5);
         case 'ACQ'
            % Updates count and writes stimulus
            sn    = sn+1;
            par	= sscanf(tline(nchar+1:end),'%d%d',[2,1]); % could also be 3
            
            block(bn).trial(tn).stim(sn).modality		= 'data acquisition';
            block(bn).trial(tn).stim(sn).onevent		= par(1);
            block(bn).trial(tn).stim(sn).ondelay		= par(2);
      end
      
   
   end
   cfg		= pb_vLookup(cfg);
   
   %% EXTRA:  Azimuth Elevation
   for iBlck = 1:cfg.Blocks
      ntrials = length(block(iBlck).trial);
      for iTrl = 1:ntrials % for every trial
         s			= block(iBlck).trial(iTrl).stim;
         block(iBlck).trial(iTrl).nstim = numel(s); % number of stimuli per trial
         for stmIdx	= 1:block(iBlck).trial(iTrl).nstim % for every stimulus in a trial
            X			= block(iBlck).trial(iTrl).stim(stmIdx).X;
            Y			= block(iBlck).trial(iTrl).stim(stmIdx).Y;
            mod			= block(iBlck).trial(iTrl).stim(stmIdx).modality;
            if ~isempty(X) % for every stimulus that has an X and Y parameter, determine azimuth and elevation
               if cfg.Lab==1 % Hoop lab
                  if strcmpi(mod,'sky')
                     [Az,El] = hoopsky2azel(X,Y);
                  else
                     [Az,El]	= hoopXY2azel(X,Y);
                  end
               elseif ismember(cfg.Lab,[2 3]) % Sphere lab
                  channel = cfg.interpolant(X,Y);
                  Az		= cfg.lookup(channel+1,5);
                  El		= cfg.lookup(channel+1,6);
               elseif ismember(cfg.Lab,4) % SphereMinor lab
                  channel = cfg.interpolant(X,Y);
                  Az		= cfg.lookup(channel+1,4);
                  El		= cfg.lookup(channel+1,5);
               elseif ismember(cfg.Lab,5) % vPrime lab
                  channel = cfg.interpolant(X,Y);
                  Az		= cfg.lookup(channel+1,4);
                  El		= cfg.lookup(channel+1,5);
               end
               block(iBlck).trial(iTrl).stim(stmIdx).azimuth		= Az;
               block(iBlck).trial(iTrl).stim(stmIdx).elevation    = El;
            end
         end
      end
   end
   
   %% CHECK OUT
	fclose(fid);
end

function comment = checkcomment(fid)
   isComment	= true;
   cnt			= 0; % counter
   comment		= cell(1);
   while isComment % do this for every line that starts with '%'
      position	= ftell(fid); % find the position in the file
      str			= fscanf(fid,'%s',1); % read the string (moving the position in the file)
      commentline = fgetl(fid); % get the entire line (again repositioning)
      isComment	= strncmp(str,'%',1); % and check whether the first string of the line actually indicated a comment
      if ~isempty(commentline) && isComment
         cnt				= cnt+1;
         comment(cnt)	= {commentline};
      end
   end
   fseek(fid,position,'bof');
end

function cfg = hread(fid,cfg)
   cnt = 0;
   isBody = false;
   header = cell(1);
   
   while ~isBody
      position	= ftell(fid);
      str      = fscanf(fid,'%s',1);
      isBody   = strcmp(str,'~~~');  
      if ~isBody
         fseek(fid,position,'bof');
         cnt			= cnt+1;
         header(cnt)	= {fscanf(fid,'%s',1)};
         switch lower(header{cnt})
            case 'iti' % Inter-trial interval
               cfg.(header{cnt})	= fscanf(fid,'%d %d',[2 1]); % 2 integers: minimum and maximum possible inter trial interval
            case 'motor' % Motor
               cfg.(header{cnt})	= fscanf(fid,'%s',1); % String: yes or no
            otherwise
               cfg.(header{cnt})	= fscanf(fid,'%d',1); % Integer
         end
         checkcomment(fid);
      end  
   end
end

function signal = readVest(line)
   types = {'none','sine','noise','turn'};
   n = str2num(erase(sscanf(line,'%s',2),sscanf(line,'%s',1)))+1;
   type  = types{n};
   signal.type = type;
   if ~strcmp(type,'none')
      signal.amplitude  = str2double(erase(sscanf(line,'%s',3),sscanf(line,'%s',2)));
      signal.duration   = str2double(erase(sscanf(line,'%s',4),sscanf(line,'%s',3)));
   end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

