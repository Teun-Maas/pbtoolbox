function [Sounds,Check] = runWavPlay(RZ6_x,zBus,signal,attenuation,delay,device,channel)
   %runWavPlay [Sounds,Check] = runWavPlay(RZ6_x,zBus,signal,attenuation,delay,device,channel)
   %   Sounds fields: in, out, recorded;
   %	Check fields: end positions of the different buffers
   % Reset trigger
   zBus.zBusTrigA(0, 0, 2);

   % calculate or set parameters
   nsamples = length(signal);
   
   % Set parameters
   RZ6_x.SetTagVal('bufferSize',nsamples);                                 % [ms]
   
   % and the sound source
   RZ6_x.WriteTagV('soundIn',0,signal);

   RZ6_x.SetTagVal('delaySND',delay);                                      % [ms] (probs not important here)
   RZ6_x.SetTagVal('eventSND',1); 


   % Set MUXes
   MUX(RZ6_x,device,channel);
   RZ6_x.SetTagVal('attenuationA',attenuation);                            % Use 2 to enable separate channels later
   RZ6_x.SetTagVal('attenuationB',attenuation);

   % Trigger (software trigger is appropriate for this experiment)
   zBus.zBusTrigB(0, 0, 2);                                                % start event 1/trial onset; 
   pause(nsamples/RZ6_x.GetSFreq);                                         % Wait in case 'Active' doesn't work properly)
   while RZ6_x.GetTagVal('Active') 
      pause(0.05)                                                          % wait...
   end

   % Outputs (to perform checks)
   Check.position    = RZ6_x.GetTagVal('bufferPos');
   Check.posEndIn    = RZ6_x.GetTagVal('posIn');
   Check.posEndOut   = RZ6_x.GetTagVal('posOut');

   % Save the sounds in a struct for offline analysis.
   Sounds.in         = RZ6_x.ReadTagV('soundIn',0,nsamples);
   Sounds.store      = RZ6_x.ReadTagV('soundOut',0,nsamples);
   Sounds.out        = RZ6_x.ReadTagV('input2',0,nsamples);
   Sounds.recorded   = RZ6_x.ReadTagV('Recording',0,nsamples);
end

