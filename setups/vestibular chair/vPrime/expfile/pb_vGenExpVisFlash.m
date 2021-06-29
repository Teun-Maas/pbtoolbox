function pb_vGenExpVisFlash(varargin)
% PB_VGENEXP_VIS
%
% PB_VGENEXP_VIS  will generate an EXP-file for a default localization experiment. 
% EXP-files are used for the psychophysical experiments at the
% Biophysics Department of the Donders Institute for Brain, Cognition and
% Behavior of the Radboud University Nijmegen, the Netherlands.
%
% VESTIBULAR STIMULATION PARAMETERS:
%
% Vestibular signals:      1) none, 
%                          2) sine, 
%                          3) noise, 
%                          4) turn, 
%                          5) step,
%                          6) sum of sines.
%
% Azimuth rotation:        VER
% Elevation rotation:      HOR
%
% See also PB_VWRITEHEADER, PB_VWRITESIGNAL, PB_VWRITETRIAL, PB_VWRITESTIM, etc

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl

   %% Initialization
   %  Clear, empty, default imputs 

   pb_clean;
   disp('>> GENERATING VC EXPERIMENT <<');
   disp('   ...')

   cfn = 0;
   
   % Make default expfile name
   fn = get_fn(dbstack);   % Read .m filename

   % Varargin
   GV.show_exp       = pb_keyval('showexp',varargin,true);
   GV.show_targets   = pb_keyval('showtargets',varargin,true); 
   GV.expfile        = pb_keyval('fname',varargin,[fn '.exp']); 
   GV.datdir         = pb_keyval('datdir',varargin,'');
   GV.cdir           = pb_keyval('cd',varargin,userpath);
   GV.open_exp       = pb_keyval('open',varargin,true);
   GV.ITI            = pb_keyval('ITI',varargin,[0 0]);
   GV.trials         = pb_keyval('ntrials',varargin,39);
   GV.stim           = pb_keyval('stim',varargin,2);
   GV.lab            = pb_keyval('lab',varargin,1);
   GV.repeats        = pb_keyval('repeats',varargin,2);
   GV.durations      = pb_keyval('duration',varargin,[0.5 1 2 4 16]);
   GV.int            = pb_keyval('intensity',varargin,[40 50]);
   GV.onset        	= pb_keyval('onset',varargin,[1000 1250]);
   GV.randomise      = pb_keyval('random',varargin,true);
   GV.chair2world    = pb_keyval('chair2world',varargin,[1 3]);
   
   % Build experiment
   T     = get_targets(GV);
   S     = get_stimuli(T,GV);
   EXP   = parse_exp(S,GV);
   
   % Write experiment
   c_expfiles = write_exp(EXP,GV);
   open_exp(c_expfiles,GV);
end


% Helper functions
function EXP = parse_exp(S,GV)
   % This function will parse stimuli over different blocks and add
   % vestibular signal to each block.

   nblocks = floor(length(S.X)/GV.trials);    % compute number of blocks

   for iB = 1:nblocks
      % divbide stimuli over blocks
      
      idc = (iB-1)*GV.trials+1 : iB*GV.trials;     % select current stimuli idc
      
      % split stimuli
      EXP.block(iB).Stim.X       = S.X(idc);
      EXP.block(iB).Stim.Y       = S.Y(idc);
      EXP.block(iB).Stim.dur     = S.dur(idc);
      
      % inset other parameters
      EXP.block(iB).Stim.int     = randi(GV.int,size(idc'));
      EXP.block(iB).Stim.onset   = randi(GV.onset,size(idc'));
      EXP.block(iB).Stim.offset  = EXP.block(iB).Stim.onset + EXP.block(iB).Stim.dur;
      
      EXP.block(iB).Horizontal   = struct('Amplitude', 0,  'Signal', 1, 'Duration', 200, 'Frequency', 0.16);
      EXP.block(iB).Vertical     = struct('Amplitude', 70, 'Signal', 2, 'Duration', 200, 'Frequency', 0.16);
   end
end


function S = get_stimuli(T,GV)
   % This function will prep all stimuli * durations

   % Make stim grid
   [X,Y]          = make_stims(T,GV);
   dur            = GV.durations;
   [X,~,~]      	= ndgrid(X,0,dur);
   [Y,~,dur]     	= ndgrid(Y,0,dur);
   
   % Vectors
   X              = X(:);
   Y              = Y(:);
   dur            = dur(:);
   
   % Repeat
   S.X     = repmat(X,[GV.repeats 1]);
   S.Y     = repmat(Y,[GV.repeats 1]);
   S.dur   = repmat(dur,[GV.repeats 1]);
   
   if GV.randomise   % shuffle targets
      rperm    = randperm(length(S.X));   % random key
      
      % shuffle
      S.X      = S.X(rperm);
      S.Y      = S.Y(rperm);
      S.dur   	= S.dur(rperm);
   end
end

function [X,Y] = make_stims(T,GV)
   % this function will select the target positions and correct them for the
   % relative ratio of presenting them (world vs chair fixed targets)
    
   world_fixed    = T(:,1) == 90;   % azimuth check, 90 is world fixed
   X              = [repmat(T(~world_fixed,1), GV.chair2world(1),1); ...
                     repmat(T(world_fixed,1),  GV.chair2world(2),1)];      
                  
   Y              = [repmat(T(~world_fixed,2), GV.chair2world(1),1); ...
                     repmat(T(world_fixed,2),  GV.chair2world(2),1)];
end


function T = get_targets(GV)
   % This function  will obtain all targets from cfg, and remove targets
   % too close to elevation = 0.

   % Get targets
   cfg			= pb_vLookup;                  % lookup target positions
   L        	= cfg.lookup;
   cut_off     = 6;
   ntargets    = sum((abs(L(:,5))>=cut_off));
   T           = zeros(ntargets,2);          % create empty list of targets

   if GV.show_targets
      % Graph the target positions
      
      % Read lookup table
      frame    = unique(L(:,2));
      framel   = length(frame);
         
      c_title = {'Frame I','Frame II'};   
      cfn = pb_newfig(999);
      
      for iF = 1:framel
         % Run for each stimulus frame
         
         % plot different frame in subplots
         subplot(1,framel,iF);
         title(c_title{iF});
         hold on;
         axis square;
         
         % Select frame
         selF  = frame(iF) == L(:,2); 
         x     = L(selF,4);
         y     = L(selF,5);
         
         % Select targets
         selS = abs(y) >= cut_off;
         dAz   = x(selS);
         dEl   = y(selS);

         % Plot
         plot(x,y,'o');
         plot(dAz,dEl,'x');
         
         % Make nice
         pb_hline([-cut_off,cut_off]);
         ylabel('Elevtion');
         ylim([-50 50]);
         if iF<framel
            xlabel('Azimuth');
            xlim([-50 50]);
         else
            f = gca;
            f.XTickLabel = {};
         end
         
         % Store targets
         if iF == 1
            idx1 = 1; 
            idx2 = length(dAz);
         else
            idx1 = idx2+1; 
            idx2 = ntargets;
         end

         T(idx1:idx2,1)    = dAz;
         T(idx1:idx2,2)    = dEl;
      end
      
      pb_nicegraph;
   end
end


function c_expfiles = write_exp(EXP, GV)
   % write the experimental data in expfile.
   
   cd(GV.cdir);
   
   % preallocate
   c_expfiles = {};

   % Make expfile for each block
   for iB = 1:length(EXP.block)
      
      % Make expfilenames
      [ext, prefix]    = pb_fext(GV.expfile);
      c_expfiles{iB}   = [prefix '_b' num2str(iB) ext];
      
      % Build expfile
      fid = fopen(c_expfiles{iB},'wt+');
      
      % Write header
      pb_vWriteHeader(fid,1,GV.trials,GV);
      
      % Write vestibular signal
      pb_vWriteBlock(fid, 1)
      pb_vWriteSignal(fid,EXP.block(iB))
      
      % Write trials
      for iT = 1:GV.trials

         % Make visual stimulus object
         VIS.LED        = 'LED';
         VIS.X          = EXP.block(iB).Stim.X(iT);
         VIS.Y          = EXP.block(iB).Stim.Y(iT);  
         VIS.Int        = EXP.block(iB).Stim.int(iT);
         VIS.EventOn    = 0;
         VIS.EventOff   = 0;
         VIS.Onset      = EXP.block(iB).Stim.onset(iT);
         VIS.Offset     = EXP.block(iB).Stim.offset(iT);
         
         % Write trial and stimuli
         pb_vWriteTrial(fid, iT);
         pb_vWriteStim(fid, 2, [],VIS);
      end
      
      % Write 
      fclose(fid);
   end
end

function open_exp(c_expfiles,GV)
   % This function will open all created expfiles as a check
   
   if GV.open_exp    % default is true

      % Read all expfiles
      for iE = 1:length(c_expfiles)

         fn    = c_expfiles{iE};

         % Open expfile with editor
         if ismac
            system(['open -a BBEdit ' cd filesep fn]);
         elseif ispc
            dos(['"C:\Program Files\Windows NT\Accessories\wordpad.exe" ' fn ' &']);
         end
      end
   end
end

function fn = get_fn(st)
   % Get filename from stack
   
   % Read stack
   sname    = st.name;              % get fn
   ind      = strfind(sname,'_');   % if pb_something remove pb_
   if isempty(ind); ind = 0; end
   
   % Store name
   fn       = sname(max(ind)+1:end);
end

