function D = pb_detectvor(signal,varargin)
% PB_DETECTVOR
%
% PB_DETECTVOR(signal) will identify what regions of the nystagmus of an 
% eye are quick- and slowphases.
%
% Input: Eye trace (default velocity), (+ some varargin control settings).
% Output: Data struct containing:
%           - Original signal
%           - Indices of quick- and slowphases
%           - Reconstructed signal
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   % Get varargins
   V.signaltype   = pb_keyval('type',varargin,'step');
   V.measured     = pb_keyval('measured',varargin,'velocity');
   V.display      = pb_keyval('display',varargin,true);
   V.fs           = pb_keyval('fs',varargin,120);              % Pupillabs
   V.strictness 	= pb_keyval('strictness',varargin,0.5);      % 0-1
   
   % Check varargins
   if ~isnumeric(V.strictness) || V.strictness < 0 || V.strictness > 1
      error('''Strictness'' should be a numeric ranging from 0 to 1.');
   end
   
   % Check signal
   c_signaltype   = {'step','noise','sine'};
   signaltype     = lower(V.signaltype);
   
   %  Select VOR type function
   switch signaltype
      case c_signaltype{1} % step
         D = detect_step_vor(signal,V);
      case c_signaltype{2} % noise
         D = detect_noise_vor(signal,V);
      case c_signaltype{3} % sine
         D = detect_sine_vor(signal,V);
      otherwise            % you messed up bro
         error('Unknown signal type (Select either: ''step'', ''noise'', or ''sine'').'); 
   end
   
   %  Reconstruct VOR
   position    = cumsum(signal);
   quicksig    = position; quicksig(D.idx.slowphase) = nan;
   slowsig     = position; slowsig(D.idx.quickphase) = nan;
   D           = reconstruct_vor(D,V);
  
   % Visualize
   if V.display
      pb_newfig(pb_nextfigurenumber-1);
      title('Vestibulo-Ocular Reflex (clustered)');
      xlabel('Time (samples)');
      ylabel('Velocity $(^{\circ}/s)$');
      hold on;
      plot(quicksig,'.');
      plot(slowsig,'.');
      pb_nicegraph;
      legend('quick','slow');
   end
end

%  Helper functions
function D = detect_step_vor(signal,V)
   % This function will rpovide you with the indices of your quick and
   % slowphases. Note that input is assumed to be a velocity trace.
   % Algorithm is a some velocity threshold cutoff based on the variety in
   % your data.
   
   % Remove nonlinear trend from original signal
   order       = 5;
   gain_fit    = 0.5;
   t           = (1:length(signal))';
   [p,S,mu]    = polyfit(t,lowpass(signal,'Fc',0.05,'Fs',V.fs),order);
   fit_poly    = polyval(p,t,[],mu) * gain_fit;
   dt_signal   = signal - fit_poly;

   Stat        = pb_stats(dt_signal);
   vel_thresh  = 1 - (V.strictness/10);
   
   cfn   = pb_newfig(pb_nextfigurenumber-1);
   
   % Show speed
   ax(1) = subplot(121);
   hold on; axis square;
   
   h     = histogram(dt_signal,'Normalization','cdf');
   
   title('Cumulative Distribution Function')
   xlabel('Velocity ($^{\circ}/s$)')
   ylabel('Fraction');
   xlim([0 max(h.BinEdges)])
   ylim([0.9 1])
   pb_hline(vel_thresh);
   
   % Detrend
   ax(2) = subplot(122);
   hold on; axis square;
   
   f(1)  = plot(signal);
   f(2)  = plot(dt_signal);
   f(3)  = plot(fit_poly);
   
   title('Remove nonlinear trend from signal');
   legend('Signal','Detrended signal','Non linear trend');
   xlabel('Time (samples)')
   ylabel('Velocity');
   
   ylim([0 mean(abs(signal))*5])
   a = gca;
   text(max(a.XLim)*0.1,max(a.YLim)*0.75,['normr = ' num2str(S.normr,2)],'FontSize',15,'FontWeight','Bold');
   pb_nicegraph;
   
   thresh_quickphase = h.BinEdges(find(h.Values>vel_thresh,1)); % Find velocity threshold esceeding 95% of all velocities (cdf)
   
   pb_hline([thresh_quickphase, Stat.std]);
   f(3).LineWidth = 2;
   
   
   %  Store the data
   D.signal          = signal;
   D.idx.quickphase  = find(signal>thresh_quickphase);
   D.idx.slowphase   = find(signal<thresh_quickphase);
   D.idx.other       = [];
end

function data = detect_sine_vor(signal,V)
   % Input should be given in velocity
   data = struct([]);
   disp('will be implemented later on');
end

function data = detect_noise_vor(signal,V)
   % Input should be given in velocity
   data = struct([]);
   disp('will be implemented later on');
end

function D = reconstruct_vor(D,V)
   
   D.signal;
   
   D.rec_quickphase  = [];
   D.rec_quickphase  = [];
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

