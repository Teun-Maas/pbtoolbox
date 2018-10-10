function cfg = pb_tdtglobals(cfg)
% PB_TDTGLOBALS()
%
% PB_TDTGLOBALS()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
   %% TDT flags
   cfg.statTDTConnect = 1;
   cfg.statTDTLoad    = 2;
   cfg.statTDTRun     = 3;

   %% Fixed RZ6.rcx
   % cfg.RZ6Fs	= 48828.125; % Hz = default, will be replaced in 
   cfg.dataidx		= {'Data_1' 'Data_2' 'Data_3'}; % names of Data sources Do I need this? --> VC

   %% RP2 and Muxes
   % cfg.mux2rp2				= [1 2 2 1]; % which RP2 channel belongs to which MUX?
   cfg.mux2rp2				= [1 2]; % which RP2 channel belongs to which MUX?

   % cfg.recdataidx		= {'recData_1' 'recData_2'}; % names of Data sources

   %% Fixed setup (SA1 & PA5 & RP2.rcx)
    cfg.maxsndlevel		= 75; 

   %% standard variables
   if ~isfield(cfg,'RZ6_1circuit')
      cfg.RZ6_1circuit = which('vPrime_RZ6.rcx');
   end


   %% short names of TDT circuits
   [~,cfg.sRZ6_1circuit]	= fileparts(cfg.RZ6_1circuit);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

