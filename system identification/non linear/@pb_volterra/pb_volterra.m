classdef pb_volterra < matlab.mixin.Copyable
% PB_VOLTERRA
% 
% PBToolbox (2020): JJH: j.heckman@donders.ru.nl
   
   properties (GetAccess = public, SetAccess = public)
      feedforwardnet
      model
      kernels
   end
   
   properties (Access = public, Hidden = true)
      polynomial_method ='bias_correction';
      weights
      a
   end

   properties (Access = protected, Hidden = true)    
      varg
      netpar
      process
      kv
   end

   methods (Access = public)
        
      % Constructor
      function obj = pb_volterra(net,varargin)
         % Build volterra-object
         
         if nargin == 0; return; end
         
         if ~isempty(net)
            %  Assert
            if ~isa(net,'network'); error('Net is not a network class.'); end
            if net.numLayers ~= 2; error('Algorithm requires a simple 2-layer feedforward neural network'); end
            
            %  Read input arguments
            obj.kv.deriv_sigfun  = pb_keyval('dsigfun',varargin);
            obj.process.x        = pb_keyval('preprocess',varargin);
            obj.process.y        = pb_keyval('postprocess',varargin);
            obj.feedforwardnet   = net;
            
            %  Constructor functions
            obj = read_network(obj);
            obj = set_normalisation(obj,'mapminmax');
            obj = compute_polynomial_coefficients(obj);
         end
      end
      obj = set_normalisation(obj,method);
      obj = set_polynomial_method(obj,poly_method);  
      obj = compute_polynomial_coefficients(obj);
      obj = compute_volterra_kernels(obj,order);
      obj = update_kernels(obj,nets);
      obj = predict_volterra_series(obj,input);
      obj = compare(obj,input,output);
   end
   
   methods (Access = private)
      obj = read_network(obj);
   end
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

