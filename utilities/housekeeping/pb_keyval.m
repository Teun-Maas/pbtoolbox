function [val, remaining] = pb_keyval(key, varargin)
% PB_KEYVAL
%
% PB_KEYVAL(key, varargin) returns the value that corresponds to the requested key in a
% key-value pair list of variable input arguments.
%
% See also PB_GETDIR
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   emptyval = [];

   if nargin==3 && iscell(varargin{1})
      emptyval = varargin{2}; 
      varargin = varargin{1};
   end

   if nargin==2 && iscell(varargin{1})
      varargin = varargin{1};
   end

   % Is key-value pair even?
   if mod(length(varargin),2)
      error('input arguments come in key-value pairs, i.e. there should be an even number');
   end

   % the 1st, 3rd, etc. contain the keys, the 2nd, 4th, etc. contain the values
   keys = varargin(1:2:end);
   vals = varargin(2:2:end);

   valid = false(size(keys));

   for i=1:numel(keys)
      valid(i) = ischar(keys{i});
   end

   if ~all(valid)
      error('input arguments come in key-value pairs, the optional input argument %d is invalid (should be a string)', i);
   end

   hit = find(strcmpi(key, keys));
   if isempty(hit)
      % the requested key was not found
      val = emptyval;
      elseif length(hit)==1  
      % the requested key was found
      val = vals{hit};
   else
      error('multiple input arguments with the same name');
   end

   if nargout>1
      % return the remaining input arguments with the key-value pair removed
      keys(hit) = [];
      vals(hit) = [];
      remaining = cat(1, keys(:)', vals(:)');
      remaining = remaining(:)';
   end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
