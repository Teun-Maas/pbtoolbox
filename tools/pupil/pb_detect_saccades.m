function [on, off] = pb_detect_saccades(smv,conf)
% PB_DETECT_SACCADES()
%
% PB_DETECT_SACCADES()  ...
%
% See also ...

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl

 % This function will find all saccades using the smooth velocity trace

   % defaults
   THRESHOLD_VALUE 	= 30;
   MIN_LENGTH        = 5;
   MAX_LENGTH        = 60;
   MIN_CONF          = 0.85;
   WINDOW            = 5;
   MIN_DISTANCE      = 1;

   % saccade detection algorithm
   fast              = smv >= THRESHOLD_VALUE;
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
   idx      = (pot_on(2:end) - pot_off(1:end-1) < MIN_DISTANCE);
   pot_on   = pot_on(~([0 idx(1:end-1)]));
   pot_off  = pot_off(~idx);
   
   % preallocate boolean saccade data
   keep_sac          = true(size(pot_off));
   
   % iterate over the potential saccades
   for iS =  1:length(pot_off)
   % check for criteria, if not met discard saccade
      sac_len     = pot_off(iS) - pot_on(iS);
      window      = conf(pot_on(iS)-WINDOW:pot_off(iS)+WINDOW);
      
      if sac_len<MIN_LENGTH || sac_len>MAX_LENGTH || any(window<MIN_CONF)  % remove saccade if saccade is too short or the window dips below 0.8 confidence
         keep_sac(iS) = false;
      end
   end
   
   % store saccades
   on       = pot_on(keep_sac);
   off      = pot_off(keep_sac);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

