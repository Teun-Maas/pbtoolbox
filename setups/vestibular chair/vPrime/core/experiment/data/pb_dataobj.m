classdef pb_dataobj < handle
% PB_DATAOBJ()
%
% PB_VCREATEDAT()  ...
%d
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
    
    properties (Access=public)
       vestibular_signal   = [];
       pupil_labs          = [];
       optitrack           = [];
       sensehat            = [];
       event_in            = [];
       event_out           = [];
       block_info          = [];
       meta_pup            = [];
    end

    methods
        function obj = pb_dataobj(n)
            % constructor            
            if nargin ~= 0 
                if nargin < 1
                    n = 1;
                end
                obj(n,1) = pb_dataobj; % Preallocate object array
            end
        end

        function delete(obj)
            % DELETE - destructor
            delete(obj);
        end
                
        function dump(this)
            % DUMP - show the content of the internal variables
            this.vestibular_signal
            this.event_data
            this.pupil_labs 
            this.block_info
        end
    end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

