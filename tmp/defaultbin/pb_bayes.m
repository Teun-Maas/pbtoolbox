function P = pb_bayes(varargin)
% PB_BAYES()
%
% Creates a template function for PBToolbox.
%
% PB_BAYES()  ...
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
    
    prior       =   keyval('prior',varargin);           % P(A)
    normconst   =   keyval('normconst',varargin);       % P(B)
    likelihood  =   keyval('likelihood',varargin);      % P(B|A)
    posterior   =   keyval('posterior',varargin);       % P(A|B)
    
%     if nargin<3
%         disp('Not enough input parameters provided.')
%         return
%     end
    
    % posterior = prior * likelihood / normconstant
    
    
    
    
    
    
    

end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

