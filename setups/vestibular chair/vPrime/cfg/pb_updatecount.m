function cfg = pb_updatecount(cfg,varargin)
% PB_UPDATECOUNT
%
% PB_UPDATECOUNT(cfg,varargin) updates the count of trialnumber and block number during experiment
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %  initializes update information
   trial = pb_keyval('trial',varargin);
   block = pb_keyval('block',varargin);
   
   %  sets trials
   if ~isempty(trial)
      switch trial
         case 'count'
            cfg.trialnumber      = cfg.trialnumber+1;
         case 'reset'
            cfg.trialnumber(1)   = 1;
      end
   end
   
   %  sets block
   if ~isempty(block)
      switch block
         case 'count'
            cfg.blocknumber      = cfg.blocknumber+1;
      end
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 