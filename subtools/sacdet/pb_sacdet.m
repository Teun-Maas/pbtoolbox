function varargout = pb_sacdet(varargin)
% PB_SACDET MATLAB code for pb_sacdet.fig
%      PB_SACDET, by itself, creates a new PB_SACDET or raises the existing
%      singleton*.
%
%      H = PB_SACDET returns the handle to a new PB_SACDET or the handle to
%      the existing singleton*.
%
%      PB_SACDET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PB_SACDET.M with the given input arguments.
%
%      PB_SACDET('Property','Value',...) creates a new PB_SACDET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pb_sacdet_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pb_sacdet_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pb_sacdet

% Last Modified by GUIDE v2.5 03-Mar-2022 13:44:25

   % Begin initialization code - DO NOT EDIT
   gui_Singleton = 1;
   gui_State = struct('gui_Name',       mfilename, ...
                      'gui_Singleton',  gui_Singleton, ...
                      'gui_OpeningFcn', @pb_sacdet_OpeningFcn, ...
                      'gui_OutputFcn',  @pb_sacdet_OutputFcn, ...
                      'gui_LayoutFcn',  [] , ...
                      'gui_Callback',   []);
   if nargin && ischar(varargin{1})
       gui_State.gui_Callback = str2func(varargin{1});
   end

   if nargout
       [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
   else
       gui_mainfcn(gui_State, varargin{:});
   end
end
% End initialization code - DO NOT EDIT


% --- Executes just before pb_sacdet is made visible.
function pb_sacdet_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pb_sacdet (see VARARGIN)

   % Choose default command line output for pb_sacdet
   handles.output    = hObject;
   handles.filename  = 'sac_file.mat';
   set(hObject, 'color', 'w');

   % Load data
   if nargin < 4                                                           % 4th input is the extra input given to the gui function (first three are hObject, event, and handles)
      [fname, path] = pb_getfile('ext','*mapped_file*.mat');               % load data if there is no additional input argument being passed
      if ~fname; error('No data was selected'); end
      load([path filesep fname],'D');
   elseif nargin == 4 
      D = varargin{4};
      if ~isa(D(1).data.dat,'pb_dataobj') 
         error('Wrong data format (i.e. no pb_dataobj was found).');
      end
   end
   
   % Select block you want to analyse
   block_idx = select_block(D);

   % Update handles structure
   handles                       = read_pupil(handles, D(block_idx));
   handles                       = read_blockinfo(handles, D(block_idx));
   handles                       = preall_gui(hObject,handles);
   
   % synchronize timestreams
   handles.pupil_labs.ts         = handles.pupil_labs.ts    - handles.trial_onset(1);
   handles.stim_onset            = handles.stim_onset       - handles.trial_onset(1);
   handles.trial_onset           = handles.trial_onset      - handles.trial_onset(1);
   
   % Get hv traces, unfiltered.
   trace                         = stampe_filtering(handles.pupil_labs.data);
   handles.pupil_labs.x          = trace(1,:);
   handles.pupil_labs.y          = trace(2,:);
   
   handles.pupil_labs.vel        = getvel(handles.pupil_labs.x, handles.pupil_labs.y, 200);
   handles.pupil_labs.vels       = getsmooth(handles.pupil_labs.vel);                           % smooth trace for saccade detection
   
   
   %-- Graphing
   linkaxes([handles.ax_pos handles.ax_vel],'x');
   
   % Position
   axes(handles.ax_pos);
   cla;
   hold on;
   handles.title = title('Trial 1');
   ylim([-50 50]);
   xlim([0 5]);
   
   plot(handles.pupil_labs.ts, handles.pupil_labs.x);
   plot(handles.pupil_labs.ts, handles.pupil_labs.y);
   
   pb_vline(handles.trial_onset,'style','k--');                            % trial onset
   pb_vline(handles.stim_onset,'style','r--');                             % target onset

   ylabel('Position (norm)');
   handles.ax_pos.XTickLabel = {[]};

   % Velocity
   axes(handles.ax_vel);
   cla;
   hold on;
   ylim([0 50]);
   
   plot(handles.pupil_labs.ts,handles.pupil_labs.vel);
   plot(handles.pupil_labs.ts,handles.pupil_labs.vels);
   
   pb_vline(handles.trial_onset,'style','k--');                            % trial onset
   pb_vline(handles.stim_onset,'style','r--');                             % target onset
   
   xlabel('Time (s)')
   ylabel('Velocity (norm/s)');
   pb_nicegraph('linewidth',2);
   
   
   %-- Autodetect saccades
   handles           = detect_saccades(handles);
   handles           = disp_saccades(handles);
   
   
   %-- Set defaults hObject
   set(hObject,'CloseRequestFcn',@closeRequest);
   set(hObject,'WindowKeyPressFcn',@keyPress)
   guidata(hObject, handles);
   
   
   %-- Assist functions
   function handles = read_pupil(handles, D)
      % this will read all data points for pupil labs

      handles.pupil_labs.data       = D.traces.pup.data;
      handles.pupil_labs.ts         = D.traces.pup.timestamps;
      handles.pupil_labs.conf       = D.traces.pup.conf;
   end

   function handles = read_blockinfo(handles, D)
      % this will read all data points for block/trial info 

      handles.stim.block_info      	= D.data.dat.block_info;
      handles.stim.event_out      	= D.data.dat.event_out;
      handles.stim.ntrials         	= length(handles.stim.block_info.trial);
      handles.stim.nstim         	= length(handles.stim.event_out.Data)/(handles.stim.ntrials*2);
      handles.stim.stim_trig      	= 2*handles.stim.nstim-1;
      handles.stim.ts               = lsl_correct_lsl_timestamps(handles.stim.event_out);
      
      handles.trial_onset        	= handles.stim.ts(1 : 2*handles.stim.nstim : length(handles.stim.event_out.Data));
      handles.stim_onset            = handles.stim.ts(handles.stim.stim_trig : 2*handles.stim.nstim : length(handles.stim.event_out.Data));
   end

   function block_idx = select_block(D)
      % This function will look how many experimental blocks were ran (i.e. pb_dataobj blocks and will ask you for the idx to analyze)

      % count blocks 
      nblocks = 0;
      for iD = 1:length(D)
         if isa(D(iD).data.dat,'pb_dataobj') 
            nblocks = nblocks+1; 
         end
      end

      % get block of interest
      switch nblocks
         case 0
            error('No relevant data blocks could be found');
         case 1 
            block_idx = 1;
         otherwise
            block_idx = make_dialog(nblocks);
      end

      % Assist function
      function block_idx = make_dialog(N)

         choice = cell(N,1);
         for iN = 1:N; choice{iN} = ['Block ' num2str(iN)]; end

         d = dialog('Position',[500 500 250 150],'Name','Select One');

         uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 80 210 40],...
           'String','Select the block you want to analyse');

         uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[75 70 100 25],...
           'String',choice,...
           'Callback',@popup_callback);

         uicontrol('Parent',d,...
           'Position',[89 20 70 25],...
           'String','Continue',...,
           'Enable','on',...
           'Callback','delete(gcf)');

         block_string = 'Block 1';

         % Wait for d to close before running to completion
         uiwait(d);

         block_idx = str2double(strrep(block_string,'Block ',''));

         function popup_callback(popup,~)
            idx            = popup.Value;
            popup_items    = popup.String;
            block_string   = char(popup_items(idx,:));
         end
      end
   end
end


% UIWAIT makes pb_sacdet wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Executes when user attempts to close YourGuiName.
function closeRequest(hObject, ~, ~)
% hObject    handle to YourGuiName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
   selection = questdlg('Close GUI?',...
                        'Close Request Function',...
                        'Yes','No','Yes');

   h = guidata(hObject);

   Data.pupil_labs   = h.pupil_labs;
   Data.saccades     = h.S;

   switch selection
      case 'Yes'
         assignin('base','SACDATA',Data);
         delete(hObject);
      case 'No'
         return
   end
end


% --- Outputs from this function are returned to the command line.
function varargout = pb_sacdet_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

   % Get default command line output from handles structure
   varargout{1}      = handles.output;
end


%% Buttons / Navigate functions
%
% --- Executes on button press in trial_next.
function handles = trial_next_Callback(hObject, ~, handles)
% hObject    handle to trial_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

   ts_t = handles.trial_onset;
   
   current_time         = handles.ax_pos.XLim(1);
   current_trial        = find(ts_t>=current_time,1);
   next_trial           = current_trial+1;
   
   if next_trial <= length(ts_t)
      % if there is a next trial
      delete(handles.current_patches);
      handles.current_patches  = gobjects(0);
      
      handles.ax_pos.XLim           = [ts_t(next_trial) ts_t(next_trial)+5];
      handles.title.String          = ['Trial ' num2str(next_trial)];
      handles = disp_saccades(handles);
      
      guidata(hObject, handles);
   end
end

% --- Executes on button press in trial_prev.
function handles = trial_prev_Callback(hObject, ~, handles)
% hObject    handle to trial_prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

   ts_t                 = handles.trial_onset;
   
   current_time         = handles.ax_pos.XLim(1);
   current_trial        = find(ts_t>=current_time,1);
   prev_trial           = current_trial-1;
   
   if prev_trial > 0
      % if there is a previous trial
      delete(handles.current_patches);                                     %remove previous patches
      handles.current_patches  = gobjects(0);
       
      handles.ax_pos.XLim     = [ts_t(prev_trial) ts_t(prev_trial)+5];
      handles.title.String    = ['Trial ' num2str(prev_trial)];
      handles                 = disp_saccades(handles);
      
      guidata(hObject, handles);
   end
end

% --- Executes on button press in p_right.
function p_right_Callback(hObject, ~, handles) %#ok
% hObject    handle to p_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

   handles.ax_pos.XLim = [handles.ax_pos.XLim(1)+3 handles.ax_pos.XLim(2)+3];
   guidata(hObject, handles);
end


% --- Executes on button press in p_left.
function p_left_Callback(hObject, ~, handles) %#ok
% hObject    handle to p_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

   handles.ax_pos.XLim = [handles.ax_pos.XLim(1)-3 handles.ax_pos.XLim(2)-3];
   guidata(hObject, handles);
end

% --- Executes on button press in p_insert.
function handles = p_insert_Callback(~, ~, handles) 
% hObject    handle to p_insert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

   % This function will let you manually insert a saccade within a trial
   
   % select location of new saccade
   [x,~]    = ginput(2);
   on       = find(handles.pupil_labs.ts>x(1),1);
   off      = find(handles.pupil_labs.ts>x(2),1);
   x        = handles.pupil_labs.ts([on off off on]);

   % nest it within the displayed saccades
   last     = size(handles.current_patches,1)+1;
   current  = handles.current_saccade(2);
   
   for iA = 1:2

      switch iA
         case 1
            axes(handles.ax_pos); %#ok
            y     = [min(handles.ax_pos.YLim) min(handles.ax_pos.YLim) max(handles.ax_pos.YLim) max(handles.ax_pos.YLim)];
         case 2
            axes(handles.ax_vel); %#ok
            y     = [min(handles.ax_vel.YLim) min(handles.ax_vel.YLim) max(handles.ax_vel.YLim) max(handles.ax_vel.YLim)];
      end
      
      handles.current_patches(current,iA).FaceAlpha = 0.1;
      handles.current_patches(last,iA) = patch(x,y,'green','FaceAlpha',0.3,'Linewidth',2);
   end
   
   % Find the order of the patches 
   start = zeros(1,last);
   for iP = 1:last 
      start(iP) = handles.current_patches(iP,1).XData(1);
   end
   
   [~,order] = sort(start);
   handles.current_patches = handles.current_patches(order,:);             % shuffle
   
   % set new current selected saccade
   new_current             = find(order==last);
   handles.current_saccade = handles.current_saccade + (new_current-current);
      
   % store it in the handles
   [handles.sac_on,order]  = sort([handles.sac_on on]);                    % shuffle
   handles.sac_off         = [handles.sac_off off];
   handles.sac_off         = handles.sac_off(order);
end


% --- Executes on button press in p_del.
function handles = p_del_Callback(hObject, ~, handles) 
% hObject    handle to p_del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   
   if ~isempty(handles.current_patches)
      % Delete selected saccades
      idx            = handles.current_saccade;    % get total idx / trial idx
      patchsz        = size(handles.current_patches,1); %#ok

      % Delete patches
      delete(handles.current_patches(idx(2),:));   


      % Remove saccade from handles
      handles.current_patches(idx(2),:)            = [];
      handles.sac_on(idx(1))                       = [];
      handles.sac_off(idx(1))                      = [];

      if ~isempty(handles.current_patches)
      patchsz 	= size(handles.current_patches,1);

         for iA = 1:2
            if patchsz >= idx(2)
               handles.current_patches(idx(2),iA).FaceAlpha    = 0.3;
            elseif patchsz > 0
               handles.current_saccade                         = handles.current_saccade-1;
               idx                                             = handles.current_saccade;
               handles.current_patches(idx(2),iA).FaceAlpha    = 0.3;
            end  
         end
      end
      
      % Update handles
      guidata(hObject, handles)
   end
end

function handles = save_data(hObject,handles)
   % This function will save all relevant info from sacdet and store it in
   % a sac file

   %  Get trial data
   trial_onset    = handles.trial_onset-handles.trial_onset(1);
   trial_offset   = [trial_onset(2:end) trial_onset(end)+max(diff(trial_onset))];
   
   % Get stim data
   stim           = handles.stim(1).block_info;
   
   % Get saccade data
   sac_on_idx     = handles.sac_on;
   sac_on         = handles.pupil_labs.ts(sac_on_idx);
   sac_on         = sac_on(sac_on>=0);
   sac_off_idx    = handles.sac_off;
   sac_off        = handles.pupil_labs.ts(sac_off_idx);
   sac_off        = sac_off(sac_off>=0);
   
   % Build Sac var
   NPAR           = 21;                                                    % cnt / trial / nsactrial / 18 paramaters
   Sac            = zeros(length(sac_on),NPAR);                            % Preallocate var for speed
   cnt            = 1;                                                     % Initialize cnt
   
   for iT = 1:length(trial_onset)
      % Run over all trials
      
      % determine the number of saccades within a trial
      sel_sac = find(sac_on>=trial_onset(iT) & sac_on<trial_offset(iT));

      
      for iS = 1:length(sel_sac)
         % Run over all saccades
         
         % Saccade index
         Sac(cnt,1)     = cnt; 
         
         % Trial index
         Sac(cnt,2)     = iT;
         
         % Sac idx in trial
         Sac(cnt,3)     = iS;
         
         % Sac onset index 
         Sac(cnt,4)     = sac_on_idx(cnt);
                  
         % Sac offset index 
         Sac(cnt,5)     = sac_off_idx(cnt);
         
         % Sac onset index 
         Sac(cnt,6)     = sac_on(cnt);
                  
         % Sac offset index 
         Sac(cnt,7)     = sac_off(cnt);
         
         % Stim onset
         s              = stim.trial(1).stim(2);
         Sac(cnt,8)     = s.ondelay/1000;
         
         % Stim ofset
         Sac(cnt,9)     = s.offdelay/1000;
         
         % Stim durset
         Sac(cnt,10)  	= (s.offdelay - s.ondelay)/1000;
         
         
         
         cnt =  cnt+1;  % count
      end
   end
   
   
   

   guidata(hObject, handles);
   uisave('Sac',handles.filename);
end

%% ALL THINGS SACCADES

function handles = detect_saccades(handles)
   % This function will find all saccades using the smooth velocity trace

   % defaults
   threshold_vel     = 20;
   minimum_length    = 5;
   maxmimum_length   = 70;
   minimum_conf      = 0.75;
   window_extra      = 50;
   minimum_distance  = 10;
   
   % data
   smv               = handles.pupil_labs.vels;
   conf              = handles.pupil_labs.conf;

   % saccade detection algorithm
   fast              = smv >= threshold_vel;
   change            = [0, diff(fast)];
   
   % potential saccades
   pot_on            = find(change == 1);
   pot_off           = find(change == -1);
   
   % dont start or stop mid saccade
   if pot_off(1) < pot_on(1); pot_off = pot_off(2:end); end                % make sure the first change is upwards
   if pot_off(end) < pot_on(end); pot_on = pot_on(1:end-1); end            % make sure the last change is downwards again
   
   % remove saccades to close to the beginning
   start_idx      = sum(find(pot_on<100))+1;                               % remove saccades to close to the start
   pot_on         = pot_on(start_idx:end);
   pot_off        = pot_off(start_idx:end);

   % remove saccades to close to the end
   stop_idx       = length(find((length(smv)-pot_on)<100));                % remove any saccades to close to the end
   pot_on         = pot_on(1:end-stop_idx);
   pot_off        = pot_off(1:end-stop_idx);
   
   % merge saccades to close to eachother
   idx      = (pot_on(2:end) - pot_off(1:end-1) < minimum_distance);
   pot_on   = pot_on(~([0 idx(1:end-1)]));
   pot_off  = pot_off(~idx);
   
   % preallocate boolean saccade data
   keep_sac          = true(size(pot_off));
   
   % iterate over the potential saccades
   for iS =  1:length(pot_off)
   % check for criteria, if not met discard saccade
      sac_len     = pot_off(iS) - pot_on(iS);
      window      = conf(pot_on(iS)-window_extra:pot_off(iS)+window_extra);
      
      if sac_len<minimum_length || sac_len>maxmimum_length || any(window<minimum_conf)  % remove saccade if saccade is too short or the window dips below 0.8 confidence
         keep_sac(iS) = false;
      end
   end
   
   % store saccades
   handles.sac_on       = pot_on(keep_sac);
   handles.sac_off      = pot_off(keep_sac);
   
   handles.sac_on       = correct_onoff(handles, handles.sac_on,'onset');
   handles.sac_off      = correct_onoff(handles, handles.sac_off,'offset');
end

function idc = correct_onoff(handles, sac_idc, direction)
   % This function will prolong saccades to match full duration instead of
   % threshold 2 threshold time

   % Get data
   smv         = handles.pupil_labs.vels;
   idc         = zeros(size(sac_idc));      
   samplelen   = 7;                       % This is the max window arround the idx
   
   for iS = 1:length(sac_idc)
      % Iterate over all saccade idc

      idx         = sac_idc(iS);
      
      % Check wether it is on or offset
      switch direction
         case 'onset'
            sample         = smv((idx-samplelen+1):idx);    % get sample
            elpmas         = fliplr(sample);                % flip it
            delpmas        = diff(elpmas);                  % show difference
            
            % find minimum
            local_min      = find(delpmas>=0,1);            % find first local minimum
            if isempty(local_min); local_min = samplelen; end
            
            idc(iS)        = idx+1-local_min;            	% update index

            
         case 'offset'
            sample         = smv((idx:idx+samplelen-1));    % get sample
            dsample     	= diff(sample);                  % show difference
            
            % find minimum
            local_min      = find(dsample>=0,1);            % find first local minimum
            if isempty(local_min); local_min = samplelen; end
            idc(iS)        = idx+local_min-1;            	% update index
      end
   end
end


function handles = select_saccade(hObject,handles,direction)
% This function will select a saccade based on the direction

   % if there are no more patches there aren't any saccades left within trial to select
   if isempty(handles.current_patches) 
      switch direction
         case 'next'
            handles = trial_next_Callback(hObject, [], handles); 
         case 'previous'
            handles = trial_prev_Callback(hObject, [], handles); 
      end
      return
   end 	
   
   current_sac_idx	= handles.current_saccade(2);                         % get current selected saccade within trial
   
   switch direction
      case 'next'
         % Find the next saccade
         patchsz        = size(handles.current_patches,1);

         if current_sac_idx<patchsz
            handles.current_saccade = handles.current_saccade+1;

            for iA = 1:2
               handles.current_patches(current_sac_idx,iA).FaceAlpha      	= 0.1;
               handles.current_patches(current_sac_idx+1,iA).FaceAlpha   	= 0.3;
            end
         else
            handles = trial_next_Callback(hObject, [], handles);
         end
         
      case 'previous'
         % Find the previous saccade
         if current_sac_idx>1
            handles.current_saccade = handles.current_saccade-1;

            for iA = 1:2
               handles.current_patches(current_sac_idx,iA).FaceAlpha      	= 0.1;
               handles.current_patches(current_sac_idx-1,iA).FaceAlpha   	= 0.3;
            end
         else
            handles = trial_prev_Callback(hObject, [], handles);
         end
   end
end

function handles = disp_saccades(handles)
   
   % get axis
   h(1) = handles.ax_pos;
   h(2) = handles.ax_vel;
   
   t1    = h(1).XLim(1);
   t2    = h(1).XLim(2);
      
   % select data
   sac_bool       = handles.pupil_labs.ts(handles.sac_on) > t1 & handles.pupil_labs.ts(handles.sac_on) < t2; 
   sac_on         = handles.sac_on(sac_bool);
   sac_off        = handles.sac_off(sac_bool);
   
   for iS = 1:length(sac_on)
      
      alpha_col = 0.1;
      if iS==1; alpha_col = 0.3; end

      for iA = 1:length(h)
         % Patch position
         axes(h(iA)); %#ok
         
         t1    = handles.pupil_labs.ts(sac_on(iS));
         t2    = handles.pupil_labs.ts(sac_off(iS));
         
         x     = [t1 t2 t2 t1];
         y     = [min(h(iA).YLim) min(h(iA).YLim) max(h(iA).YLim) max(h(iA).YLim)];
         handles.current_patches(iS,iA) = patch(x,y,'green','FaceAlpha',alpha_col,'Linewidth',2);
      end
   end
   
   handles.current_saccade = [find(sac_bool==1,1) 1];                      % select the total saccade number in list / and within trial
end

function [f,P] = get_sac_power(trace) %#ok
   % Compute power content of saccade in freq domain
   
   % Get length fft
   N     = 11;
   len   = 2^N;
   
   trace = trace-(mean(trace));              % remove the mean DC noise
   
   % Flip mirror to remove high frequency noise of cutoff
   x                    = ones(1,len) * trace(end);
   x(1:length(trace))   = trace;
   x                    = fliplr(x);   
   x(1:length(trace))   = trace;       
   
   % compute fft
   [~,f,P] = pb_fft(x,200);
end

function handles = preall_gui(hObject, handles)
   % will clear GUI data

   if isfield(handles, 'S'); handles = rmfield(handles,'S'); end
      
   % Data initialization
   handles.S.saccades         = [];
   handles.S.veltrace         = {};
   handles.S.power            = {};
   handles.saccade_lines    	= {};
   handles.saccade_patches    = {};
     
   guidata(hObject,handles);
end

function keyPress(hObject, eventdata)
% This function will coordinate different keystrokes with functionality

   keystroke   = eventdata.Key;
   handles     = guidata(hObject);
   
      switch lower(keystroke)
      
         % Insert saccade
         case 'i'
            handles = p_insert_Callback(hObject, [], handles);

         % Delete saccade
         case 'd'
            handles = p_del_Callback(hObject,[],handles);

         % Next saccade
         case 'n'
            handles = select_saccade(hObject,handles,'next');

         % Previous saccade
         case 'p'
               handles = select_saccade(hObject,handles,'previous');

         % Next trial
         case 'rightarrow'
            handles = trial_next_Callback(hObject, [], handles);

         % Previous trial
         case 'leftarrow'
            handles = trial_prev_Callback(hObject, [], handles);
         
         % Save data
         case 's'
            handles = save_data(hObject,handles);
      end
      
   % store saccade info
   guidata(hObject,handles)
end


%% Velocity and filtering functions

function    [fc,order] = get_filtersettings %#ok
   % This function will find the default filter settings

   fc       = [Inf, 80, 75, 50, 40, 35, 30, 25];
   order    = [  0, 10, 10,  9,  9,  9,  5,  5];
end


function trace = bw_filtering(trace,fc,order) %#ok
   % See Mack et al 2017 for best filter settings: 200Hz + high noise -->
   
   [b,a]    = butter(order,fc/(200/2));
   
   for iO = 1:size(trace,1)
      trace(iO,:) = filtfilt(b,a,trace(iO,:));
   end
end


function trace = stampe_filtering(trace)
   % Function will implement a set of 2 heuristic filters (Stampe, 1993) 
   
   for iO = 1:size(trace,2)
      trace(:,iO) = filter1(trace(:,iO));
      trace(:,iO) = filter2(trace(:,iO));
   end
   
   function x = filter1(x)
      % 1 sample delay filter
      for iP = 3:length(x)
         if(x(iP-2)>x(iP-1) && x(iP-1)<x(iP))
            if abs(x(iP-1)-x(iP))< abs(x(iP-1)-x(iP-2))
               x(iP-1)  = x(iP);
            else
               x(iP-1)  = x(iP-2);
            end
         elseif (x(iP-2) < x(iP-1) && x(iP-1) > x(iP))
            if abs(x(iP-1)-x(iP)) < abs(x(iP-1)-x(iP-2))
               x(iP-1)=x(iP);
            else
               x(iP-1)=x(iP-2);
            end
         end
      end
   end
   
   function x = filter2(x)
      % 3 sample delay filter
      for j = 4:length(x)
          if x(j-2) == x(j-1)
              if x(j) ~= x(j-1)
                  if x(j-2) ~= x(j-3)
                      % replace x1 en x2 with closest of x3 or x
                      if abs(x(j-1)-x(j)) < abs(x(j-1)-x(j-3))
                          x(j-1)    = x(j);
                      else
                          x(j-1)    = x(j-3);
                      end
                      if abs(x(j-2)-x(j)) < abs(x(j-2)-x(j-3))
                          x(j-2)    = x(j);
                      else
                          x(j-2)    = x(j-3);
                      end
                  end
              end
          end
      end
   end
end

function veltrace = getvel(htrace,vtrace,Fsample)
   % Obtain radial velocity from horizontal HOR and vertical VER traces.

   % Get the dimensionless movement, R.
   Rx                                     = htrace;
   Ry                                     = vtrace;
   R                                      = NaN*Rx;
   veltrace                             	= R;

   % Compute velocty
   Rx(:)                                  = gradient(Rx(:),1);
   Ry(:)                                  = gradient(Ry(:),1);
   R(:)                                   = hypot(Rx(:),Ry(:));
   R(:)                                   = cumsum(R(:));

   veltrace(:)                            = gradient(R(:),1./Fsample);
end

function smv    = getsmooth(vel)
   % This function will smooth the velocity trace to allow rough automatic
   % saccade detection

   % defaults
   fs       = 200; 
   sd       = 0.02;
   sdextra  = 5;
   
   % Get velocity
   x           = vel(:)';
   nextra      = round(sdextra*sd*fs);
   nx          = length(x);
   nfft        = nx+2*nextra;

   if rem(nfft,2)    % nfft odd
       frq     = [0:(nfft-1)/2 (nfft-1)/2:-1:1];
   else
       frq     = [0:nfft/2 nfft/2-1:-1:1];
   end
   x           = [x(nextra+1:-1:2) x x(end:-1:end-nextra+1)];           % mirror edges to go around boundary effects

   % Determine gaussian
   g           = normpdfun(frq,0,sd*fs);
   g           = g./sum(g);

   y           = real(ifft(fft(x).*fft(g)));
   smv       	= y(nextra+1:end-nextra);
end




%% CHANGEE

% % --- Executes on button press in insert_stat.
% function save/read_saccades_Callback(hObject, ~, handles, range) %#ok
% % hObject    handle to insert_stat (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
%    if nargin < 4
%       
%       % Select stationary onset and offset
%       x1 = ginput(1);
%       axes(handles.ax_pos);
%       h(1) = pb_vline(x1(1),'color','g');   
%       axes(handles.ax_vel);
%       h(2) = pb_vline(x1(1),'color','g');
% 
%       x2 = ginput(1);
%       axes(handles.ax_pos);
%       h(3) = pb_vline(x2(1),'color','g');   
%       axes(handles.ax_vel);
%       h(4) = pb_vline(x2(1),'color','g');
%       
%    else
%       
%       % Create saccades from SACDATA
%       x1 = range(1);
%       x2 = range(2);
%       axes(handles.ax_pos);
%       h(1) = pb_vline(x1(1),'color','g');   
%       h(2) = pb_vline(x2(1),'color','g');  
%       
%       axes(handles.ax_vel);
%       h(3) = pb_vline(x1(1),'color','g');
%       h(4) = pb_vline(x2(1),'color','g');   
%    end
%  
%    % Patch position
%    axes(handles.ax_pos);
%    x     = [x1(1) x2(1) x2(1) x1(1)];
%    y     = [min(handles.ax_pos.YLim) min(handles.ax_pos.YLim) max(handles.ax_pos.YLim) max(handles.ax_pos.YLim)];
%    hp(1) = patch(x,y,'red','FaceAlpha',0.1,'Linewidth',2);
%    
%    % Patch velocity
%    axes(handles.ax_vel);
%    x     = [x1(1) x2(1) x2(1) x1(1)];
%    y     = [min(handles.ax_vel.YLim) min(handles.ax_vel.YLim) max(handles.ax_vel.YLim) max(handles.ax_vel.YLim)];
%    hp(2) = patch(x,y,'red','FaceAlpha',0.1,'Linewidth',2);
%    
%    % Get idx of saccade on/offset
%    x1 = find(handles.pupil_labs.ts>=x1(1),1);
%    x2 = find(handles.pupil_labs.ts>=x2(1),1);
%    
%    % filter settings
%    [fc,order] = get_filtersettings;
%    
%    cnt      = size(handles.T(1).stationary,2)+1;
%    trace    = [handles.pupil_labs.x; handles.pupil_labs.y];                % no filter
%    
%    for iFx = 1:length(fc)
% 
%       % Read static
%       if iFx > 1 
%          trace    = bw_filtering(trace, fc(iFx), order(iFx));              % filter data
%       end
%       
%       x        = trace(1,:);
%       y        = trace(2,:);
%       v        = getvel(x,y,200);
% 
%       t        = statread(v,x1:x2);
%       fields   = fieldnames(t);
% 
%       % Fill in the fields, struct 2 matrix
%       
%       for iF = 1:length(fields)
%          handles.T(iFx).stationary(iF,cnt) = t.(fields{iF});
%       end
%       
%       handles.T(iFx).Fc                = fc(iFx);
%       handles.T(iFx).Order             = order(iFx);
%       handles.T(iFx).veltrace{end+1}   = v(x1:x2);
%    end
%    
%    % Visualization
%    handles.stationary_lines{end+1}     = h;
%    handles.stationary_patches{end+1}   = hp;
%    
% 	guidata(hObject, handles);
% end

% function s =  sacread(x,y,v,ts,range)
% 
%    svel_threshold = 10;   % 20 d/s
% 
%    % find systematic 
%    selv = v(range(1):range(2));
% 
%    cIdx = find(selv>=svel_threshold,1);                                	% see how many samples to remove at beginning
%    if ~isempty(cIdx); range(1) = range(1)+cIdx-1; end
% 
%    cIdx = find(fliplr(selv)>=svel_threshold,1);                        	% see how many samples to remove at the end
%    if ~isempty(cIdx); range(2) = range(2)-cIdx+1; end
% 
%    % select saccade info
%    s.onset_idx          = range(1);                                        % 1 
%    s.offset_idx         = range(2);                                        % 2
%    s.onset_time         = ts(range(1));                                    % 3
%    s.offset_time        = ts(range(2));
%    s.hor_onset_pos      = x(range(1));
%    s.ver_onset_pos      = y(range(1));      
%    s.hor_offset_pos     = x(range(2));
%    s.ver_offset_pos     = y(range(2));
%    s.hor_displacement   = s.hor_offset_pos - s.hor_onset_pos;   
%    s.ver_displacement   = s.ver_offset_pos - s.ver_onset_pos; 
%    s.amplitude          = hypot(s.hor_displacement,s.ver_displacement);
%    s.duration           = s.offset_time - s.onset_time;
%    s.mean_vel           = mean(v(s.onset_idx:s.offset_idx));
%    [s.peak_vel,idx]     = max(v(s.onset_idx:s.offset_idx));
%    s.pkpower            = s.duration * s.peak_vel;
%    s.time_to_peak       = idx/200;
%    s.skewness           = s.time_to_peak / s.duration;
%    s.num_of_peaks       = length(findpeaks(selv));
% end


