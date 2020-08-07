function obj = parse_data(obj,x,y)
% PARSE_DATA
%
% PARSE_DATA parses input-output pairs into randomized train and test sets
%
% See also PB_FEEDFORWARDNETWORK

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   if length(x) ~= length(y); error('Input and output data are not same size'); end

   ninput   = obj.dimensions.num_input;
   xlen     = length(x) - ninput + 1;
   count    = round(xlen * obj.train_test_ratio);
   
   % make input matrix
   randp    = randperm(xlen);
   input    = zeros(ninput,xlen);
   for iX = 1:xlen
      ind = randp(iX);
      input(1:ninput,iX) = flip(x(ind:ind+ninput-1))';
   end
   
   % make output pairs
   output   = y(ninput:end);
   output   = output(randp);
   
   % Store parsed data
   obj.data.train.x  = input(:,1:count(1));
   obj.data.test.x   = input(:,count(1)+1:end);
   obj.data.train.y  = output(1:count(1));
   obj.data.test.y   = output(count(1)+1:end);
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 