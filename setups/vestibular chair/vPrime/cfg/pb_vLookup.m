function cfg = pb_vLookup(cfg,varargin)
% PB_VLOOKUP()
%
% PB_VLOOKUP()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   switch cfg.Stim
      case 1
         cfg.lookup_table = 'vPrime Measurments.xlsx';
      case 2
         cfg.lookup_table = 'lookup_table_16_16.xlsx';
      otherwise 
         cfg.lookup_table = 'lookup_table_64_0.xlsx';
   end

  	%% LED connections
   % [Azimuth (deg) Elevation (deg) LED #]
   % azimuths and elevations were measured by Sebastian Ausili in June 2015
   cfg					= pb_vLSCpositions(cfg);
   cfg.nstimchan		= length(cfg.lookup); % number of PLC and MUX channels
   cfg.nspeakers		= length(cfg.lookup); % actual number of speakers
   cfg.stimchan		= (1:cfg.nstimchan)-1;

   %% Add missing channels
   n                 = size(cfg.lookup,1);
   cfg.lookup			= [cfg.lookup; NaN(cfg.nstimchan-n,3)]; % add missing channel data as NaNs
   sel					= ismember(cfg.stimchan,cfg.lookup(:,3)); % lookup existing channels
   cfg.missingchan   = cfg.stimchan(~sel); % get missing channels
   sel					= isnan(cfg.lookup(:,3)); % search for missing channels in lookup-table
   cfg.lookup(sel,3)	= cfg.missingchan; % put missing channel numbers in lookup-table
   cfg.lookup			= sortrows(cfg.lookup,[3 1 2]); % sort lookup-table by channel number

   %% Speakers

   cfg.nMUX          = 4; % 2 multiplexers
   cfg.nMUXbit			= 16; % 16 bits per MUX
   cfg.MUXind			= 1:cfg.nMUX;
   cfg.MUXbit			= 1:cfg.nMUXbit;

   LookUp(:,1)			= cfg.stimchan; % Stimulus channel 0-63
   idx					= LookUp(:,1)+1;
   LookUp(:,2)			= ceil(idx/(2^4));% MUX number
   idx					= mod(idx,2^4);
   idx(idx==0)			= 2^4;
   LookUp(:,3)			= idx; % TDT bit

   %% Combine
   % [PLC-Chan# RP2# MUX# BIT# AZ EL]
   cfg.lookup		= [cfg.lookup(:,3) LookUp(:,2:3) cfg.lookup(:,1)  cfg.lookup(:,2)];
   cfg.lookuplabel = {'Channel' 'MUX' 'Bit' 'Azimuth' 'Elevation'};
   % cfg.lookuplabel = {'Channel' 'RP2' 'MUX' 'Bit' 'Azimuth' 'Elevation'};


   %% Interpolant
   x		= cfg.lookup(:,4);
   y		= cfg.lookup(:,5);
   z		= cfg.lookup(:,1);
   sel		= ~isnan(x);
   x		= x(sel);
   y		= y(sel);
   z		= z(sel);
   cfg.interpolant		= scatteredInterpolant(x,y,z,'nearest');
   
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

