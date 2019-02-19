function [N,xi,h,k] = pb_binsize(x,varargin)
% PB_BINSIZE
%
% PB_BINSIZE(X,varargin) creates a distrubution for histogram plotting
%
% See also HIST

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   %% Initialization
   disp  = pb_keyval('disp',varargin,false);

   %% Bin width / number of bins
   sigma	= std(x);                  % sample standard deviation
   n		= numel(x);                % number of elements
   h		= 3.5*sigma/(n^(1/3));     % bin width
   k		= ceil((max(x)-min(x))/h); % number of bins

   %% Histogram
   xi		= linspace(min(x),max(x),k);
   N		= hist(x,xi);

   %% Graphics
   if disp
      stairs(xi,N)
      axis square;
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

