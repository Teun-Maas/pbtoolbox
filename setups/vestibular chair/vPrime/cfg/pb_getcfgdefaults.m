function handles = pb_getcfgdefaults(handles)
% PB_GETCFGDEFAULTS(HANDLES)
%
% PB_GETCFGDEFAULTS(HANDLES) initiaties default parameters into handles.
%
% See also PB_VPRIME, PB_VPRIMEGUI.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% Default parameters
   cfg.fpath		= pb_datapath; % default data folder
   cfg.date			= date;

   cd(cfg.fpath); % default data folder
   d					= dir;
   d					= d([d.isdir]);
   d					= d(3:end);
   cfg.expinitials		= {d.name};

   formatOut	= 'yy-mm-dd';
   d			= datestr(now,formatOut);
   cfg.date	= d;
   cfg.datestring = d;
   cfg.trialnumber = [1 1];      % format: [Tblock Texp]
   cfg.blocknumber = 1;

   %% TDT and PLC defaults
   cfg = pb_tdtglobals(cfg);		% TDT defaults
   
   %% TDT and PLC defaults
   cfg.nleds				= 256; % maximum number of LED configurations on PLC

   cfg.calfile				= which('vPrime.net');
   if isempty(cfg.calfile)
      cfg.calfile			= which('defaultvPrime.net');
   end

   %% Convert experimental trial
   cfg.Stim             = 1;
   cfg.lookup_table     = 'lookup_table_64_0.xlsx';
   cfg						= pb_vLSCpositions(cfg); % lookup structure

   %% Data filter coefficients
   % Do we use this?
   % cfg.Fcutoff             = 80;       % Cutoff Frequency  (Hz)
   % cfg.Order				= 50;
   % 
   % cfg.lpFilt = designfilt('lowpassfir', 'FilterOrder', cfg.Order, 'CutoffFrequency', ...
   %                     cfg.Fcutoff, 'SampleRate', cfg.RZ6Fs, 'Window', 'hamming');
               % check RZ6Fs
   %% Led colours
   cfg.ledcolours = {'g','r'}; % green and red
   

   %% handles
   handles.cfg		= cfg;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

