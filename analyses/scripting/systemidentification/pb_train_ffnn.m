%% System Identification of Vestibular Chair
%  In this script we will generate the pattern for (linear non-linear) system identification of
%  the VC.

%% Initialize
%  Load and merge data

%  Clean
path  = '/Users/jjheckman/Desktop/System Identification/models/';
cfn   = pb_clean('cd',path);
data  = 'vc_sysident_gwn_06hz.mat';
load(data);

%% Modelled signal

sig      = 1;
signal   = S(sig).Amplitude(1).Repeat(1);

x        = signal.amp * signal.tukey_signal';
y        = signal.pv.vertical(1:length(x));

%% Make and train FFN

REPS     = 5;
NODES    = 15;
DELAYS   = 15;

hmap  = zeros(NODES,DELAYS);
NN    = struct;
for iN = 1:NODES
   for iD = 1:DELAYS
      
      d        = iD;
      nsamples = length(x);

      x_inputs = zeros(d,nsamples-d);
      y_target = zeros(1,nsamples-d);

      % Create input signal and matching output
      for iDT = 1:nsamples-d
         xin            = x(iDT:iDT+d-1);
         xin            = flipud(xin);
         x_inputs(:,iDT) = xin;
         target         = y(iDT+d-1);
         y_target(iDT)   = target;
      end
      
      Rsq = zeros(1,REPS);
      for iR = 1:REPS
         %  Network
         net   = feedforwardnet(iN);
         net   = train(net,x_inputs,y_target);
         y_net = net(x_inputs);

         [r,m,b]  = regression(y_target,y_net);
         Rsq(iR)  = r^2;
         
         NN.nodes(iN).delay(iD).repeat(iR).net  = net;
         NN.nodes(iN).delay(iD).repeat(iR).rsq  = Rsq(iR);
      end
      % Get average R^2
      mrsq = mean(Rsq);
      hmap(iN,iD) = mrsq; 
   end
end

%% Map

order = 100;
nhmap = pb_normalize(hmap,'order',order);

cfn = pb_newfig(cfn);
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
yticks([0 5 10 15])

plot(8.1,4.95,'.k','MarkerSize',15);
text(8.3,5.5,'P(8,5)','FontSize',20)

%% Reconstruct y(t);
return

y_model = zeros(size(y_target));

for iM = 1:length(y_target)
   y_model(iM) = net(x_inputs(:,iM));
end

t  = 0.1:0.1:length(x)/10;
tm = d/10:0.1:(length(x)/10)-0.1;

cfn = pb_newfig(cfn);
hold on;
plot(t,x);
plot(t,y);
plot(tm,y_model);
pb_nicegraph;

title(['Trained data (N = ' num2str(N) ')'])
xlabel('Time (s)');
ylabel('Position ($^{\circ}$)');
ylim([-10 10])
legend('Input','Output','Model')
pb_vline(2.1);


%% Modelled signal

sig      = 5;
signal   = S(sig).Amplitude(1).Repeat(1);

x        = signal.amp * signal.tukey_signal';
y        = signal.pv.vertical(1:length(x));

nsamples = length(x);

x_inputs = zeros(d,nsamples-d);
y_target = zeros(1,nsamples-d);

%% Create input signal and matching output

for iD = 1:nsamples-d

   % Input
   xin            = x(iD:iD+d-1);
   xin            = flipud(xin);
   x_inputs(:,iD) = xin;
   
   % Output
   target         = y(iD+d-1);
   y_target(iD)   = target;
end

%% Reconstruct y(t);

y_model = zeros(size(y_target));

for iM = 1:length(y_target)
   y_model(iM) = net(x_inputs(:,iM));
end

t  = 0.1:0.1:length(x)/10;
tm = d/10:0.1:(length(x)/10)-0.1;

cfn = pb_newfig(cfn);
hold on;
plot(t,x);
plot(t,y);
plot(tm,y_model);
pb_nicegraph;

title(['New data (N = ' num2str(N) ')'])
xlabel('Time (s)');
ylabel('Position ($^{\circ}$)');
ylim([-10 10])
legend('Input','Output','Model')
pb_vline(2.1);