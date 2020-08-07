function [NN,hmap] = pb_feedforwardmap(x,y,varargin)
% PB_FEEDFORWARDMAP()
%
% PB_FEEDFORWARDMAP()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   REPS     = pb_keyval('repeats',varargin,3);
   NODES    = pb_keyval('nodes',varargin,3);
   DELAYS   = pb_keyval('delays',varargin,15);
   display  = pb_keyval('display',varargin,true);
   map      = pb_keyval('map',varargin,1);
   shownet  = pb_keyval('shownet',varargin,0);
   
   hmap  = zeros(NODES,DELAYS);
   NN    = struct;
   
   if ~map  % if you don't want to map the parameter space, but just train the precise parameters.
      N1 = NODES;
      D1 = DELAYS;
   else
      N1 = 1;
      D1 = 1;
   end
   
   for iN = N1:NODES
      for iD = D1:DELAYS

         d        = iD;
         nsamples = length(x);

         x_inputs = zeros(d,nsamples-d+1);
         y_target = zeros(1,nsamples-d+1);

         % Create input signal and matching output
         for iDT = 1:nsamples-d+1
            xin               = x(iDT:iDT+d-1);
            xin               = flipud(xin);
            x_inputs(:,iDT)   = xin;
            y_target(iDT)     = y(iDT+d-1);
         end

         Rsq = zeros(1,REPS);
         for iR = 1:REPS
            %  Network
            net      = feedforwardnet(iN);
            net      = train(net,x_inputs,y_target);
            y_net    = net(x_inputs);

            [r,~,~]  = regression(y_target,y_net);
            Rsq(iR)  = r^2;

            NN.nodes(iN).delay(iD).repeat(iR).net  = net;
            NN.nodes(iN).delay(iD).repeat(iR).rsq  = Rsq(iR);
         end
         % Get average R^2
         mrsq = mean(Rsq);
         hmap(iN,iD) = mrsq; 
      end
   end
   
   if display
       visualize_map(hmap)                 
   end
end

function visualize_map(hmap)
   %% Map

   order = 100;
   nhmap = pb_normalize(hmap,'order',order);

   cfn = pb_newfig(999);
   subplot(121);
   hold on;
   contourf(hmap,'LineStyle','None')
   xlabel('Delay');
   ylabel('Nodes');
   colormap(flipud(cool));
   shading interp;
   axis square;
   c = colorbar;
   c.Limits = [0.4296 1];
   title('Absolute space');
   yticks([0 5 10 15])

   subplot(122);
   hold on;

   contourf(nhmap,'LineStyle','None')
   xlabel('Delay');
   ylabel('Nodes');
   colormap(flipud(cool));
   shading interp;
   axis square;
   c = colorbar;
   c.Limits = [0 1];
   c.Ticks       = [0.0    0.2000    0.4000    0.6000    0.8000    1.0000];
   c.TickLabels  = {num2str(nthroot(c.Ticks',order),4)};
   title('Normalized space');   
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

