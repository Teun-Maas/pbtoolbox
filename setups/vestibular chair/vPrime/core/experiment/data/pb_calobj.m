classdef pb_calobj < handle
% PB_DATAOBJ()
%
% PB_VCREATEDAT()  ...
%d
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
    
    properties (Access=public)
       event_data          = [];
       pupil_labs          = [];
       block_info          = [];
    end

    methods
        function obj = pb_dataobj(n)
            % constructor            
            if nargin ~= 0 
                if nargin < 1
                    n = 1;
                end
                obj(n,1) = pb_calobj; % Preallocate object array
            end
        end

        function delete(obj)
            % DELETE - destructor
            delete(obj);
        end
                
        function dump(this)
            % DUMP - show the content of the internal variables
            this.event_data
            this.pupil_labs 
            this.block_info
        end
    end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

