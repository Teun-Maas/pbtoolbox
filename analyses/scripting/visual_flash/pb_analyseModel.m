%% Initialize

cfn   = pb_clean('cd','/Users/jjheckman/Desktop/PhD/Data/Chapter 3/');
l     = dir('merged_data1.mat');
load(l(end).name);

% Globals
NDUR        = 5;
NMODEL      = 8;
NCOND       = 2;
NSUBJ       = 3;
NPRED       = 4;

CDUR        = pb_selectcolor(NDUR,1);
CCOND       = pb_selectcolor(NCOND,2);
CSUBJ       = pb_selectcolor(NSUBJ,2);

MIN_LAT     = 0;
MAX_LAT     = 400;


%% Graph reaction times 
%  Make probit plots of data

% Make figure
cfn = pb_newfig(cfn);
sgtitle('Probit models')

cnt = 0;
for iC = 1:NCOND
% Run for condition (head free / fixed)

   for iS = 1:NSUBJ
   % Run for subjects (s001/003/004)
      cnt = cnt+1;

      if iC <= length(S(iS).condition)    
      % Check if data exists
         
         % Make subplot
         subplot(NCOND,NSUBJ,cnt)
         title([pb_sentenceCase(strrep(S(iS).condition(iC).condition,'_',' '))  ' (' S(iS).subj_id ')'])
         hold on;
         axis square;
        
         included = zeros(2,NDUR);  % preallocate
         for iD = 1:NDUR
            % Run for all stimulus durations
            
            % Select data
            rt    = S(iS).condition(iC).model_data(iD).RT;
            sel   = rt>MIN_LAT & rt< MAX_LAT;
            
            included(1,iD) = sum(sel);
            included(2,iD) = length(sel);
            
            pb_probit(rt(sel),'gcolor',CDUR(iD,:));    % plot data
         end
         
         % Write text
         x = xticks;
         y = yticks;
         
         included = sum(included,2);
         t        = text(x(3),y(1),[num2str(included(1)/included(2)*100,3) '\% included'],'FontSize',12);
      end
   end
end

pb_nicegraph('def',1);

pause(.1);

%% Graph head fixed models
%  graph head fixed

durs     = [0.5000    1.0000    2.0000    4.0000  100.0000];
c        = {'I','II','III','IV','V','VI','VII','VIII'};
 
% for iC = 1:NCOND
% % Run for condition (head free / fixed)
% 
%    for iS = 1:NSUBJ
%    % Run for subjects (s001/003/004)
%    
%       if iC <= length(S(iS).condition)    
%       % Check if data exists
%       
%          cnt      = 0;
%          cnt_c    = 0;
% 
%          % Predraw graph
%          % Build figure
%          cfn   = pb_newfig(cfn,'ws','normal');
%          sgtitle([pb_sentenceCase(strrep(S(iS).condition(iC).condition,'_',' '))  ' (' S(iS).subj_id ')']);
% 
%          % make subplots
%          for iM = 1:NMODEL
%             for iD = 1:NDUR
%                cnt = cnt+1;
%                h(iM,iD) = subplot(NMODEL,NDUR,cnt);
% 
%                if cnt < 6; title([num2str(durs(iD)) ' ms']); end
%                if mod(cnt,5) == 1; cnt_c = cnt_c+1; ylabel(c{cnt_c}); end 
% 
%                % layout
%                hold on;
%                axis square;
%                xlim([-50 50]);
%                ylim([-50 50]);
%                pb_dline;
%                pause(.1);
%             end
% 
%          end
% 
%          % Fill in data
%          for iM = 1:NMODEL
%             for iD = 1:NDUR
%                axes(h(iM,iD));
% 
%                % Select saccades
%                rt    = S(iS).condition(iC).model_data(iD).RT;
%                sel   = rt>MIN_LAT & rt< MAX_LAT;
% 
% 
%                dGx = S(iS).condition(iC).merged_saccade_data(iM,iD).dGx(sel);
%                dGy = S(iS).condition(iC).merged_saccade_data(iM,iD).dGy(sel);
% 
%                % Plot data
%                [h_lines,b,r] = pb_regplot(dGx, dGy);
% 
%                % Set colors
%                h_lines(1).Color = [0 0 0];
%                h_lines(1).MarkerFaceColor = CDUR(iD,:);
%                h_lines(1).Tag = 'Fixed';
%                
%                pause(.1);
% 
%             end
%          end
%       end
%       pb_nicegraph;
%       pause(.1);
%    end
% end
% 
% pause(.1);

%% Multiple Linear Regression EARLY - LATE

SEL_D   	= [120 400];  
SEL_T   	= 20;
NPRED 	= 3;

% draw figure
cfn = pb_newfig(cfn);
cnt = 0;
c = {'$T_R$','$\Delta C_S$','$\Delta E_H$'};

sgtitle('Multiple linear regression');


cnt = 0;
for iC = 1:NCOND
   % Run over number of conditions

   for iP = 1:NPRED
      % Run over number of predictors

      cnt = cnt + 1;

      % Draw axis
      subplot(NCOND,NPRED,cnt)
      axis square;
      hold on;

      
      if iC == 2; xlabel('Stimulus duration (ms)'); end
      if iP == 1; ylabel([pb_sentenceCase(strrep(S(iS).condition(iC).condition,'_',' ')) ' (rc)']); end


      % Define ticks and limits
      ylim([-1.5 1.5]);
      xlim([0.5 5.5]);
      xticks([1 2 3 4 5]);
      yticks([-1 0 1]);
      xticklabels({'0.5','1','2','4','100'});

      pb_hline(-1:1);

      pause(.1);

      % plot data
      for iS = 1:NSUBJ
         % Run over number of subjects

         if iC <= length(S(iS).condition)   
         % Check if data exists

         % preallocate space
         rc_data = zeros(4,5); 
         rc_err  = zeros(4,5);

            for iD = 1:NDUR
               % Run over number of durations

               % select data
               rt       = S(iS).condition(iC).model_data(iD).RT;
               t        = abs(S(iS).condition(iC).model_data(iD).G(:,2) - S(iS).condition(iC).model_data(iD).Tr(:,2));
               
               sel_D    = rt>SEL_D(1) & rt< SEL_D(2);
               sel_T    = t < SEL_T;
               sel      = sel_D & sel_T;

               %  Select predictors
               Tr = S(iS).condition(iC).model_data(iD).Tr(sel,1);
               Cs = S(iS).condition(iC).model_data(iD).Cs(sel,1);
               Eh = S(iS).condition(iC).model_data(iD).Eh(sel,1);
               G  = S(iS).condition(iC).model_data(iD).G(sel,1);

               %  Regression
               tbl      = table(Tr,Cs,Eh,G,'VariableNames',{'Tr','Cs','Eh','G'});
               lm       = fitlm(tbl,'G~Tr+Cs+Eh');
               coeff    = lm.Coefficients;

               % Store rcs
               rc_data(1:3,iD)   = table2array(coeff(2:end,1));
               rc_err(1:3,iD)    = table2array(coeff(2:end,2));
            end

         end
       	errorbar(rc_data(iP,:),rc_err(iP,:),'Tag','Fixed','color',CSUBJ(iS,:));
         pause(.1);
      end

      % compute avarage rcs
      h_dat = pb_fobj(gca,'Type','errorbar');
      %h_dat = h_dat(floor(length(h_dat)/2)+1:end);
      h_sum = errorbar(mean(vertcat(h_dat.YData)), std(vertcat(h_dat.YData)),'Tag','Fixed','color',[0.4 0.4 0.4],'LineWidth',2);
   end
end
pb_nicegraph;



%% Distributions
%  Create distribution plots of all the model's predictors

NPRED  = 4;

for iS = 1:NSUBJ
   % Run over number of subjects
         
   % draw figure
   cfn = pb_newfig(cfn);
   cnt = 0;
   c = {'$T_R$','$\Delta C_S$','$\Delta H_C$','$\Delta E_H$'};

   sgtitle(['Predictor distribution (' S(iS).subj_id ')']) 
   
   for iC = 1:NCOND
      % Run over number of conditions

      if iC <= length(S(iS).condition)
         % Check if data exists
         
         for iP = 1:NPRED
            % Run over number of predictors

            cnt = cnt + 1;

            % Draw axis
            subplot(length(S(iS).condition),NPRED,cnt);
            axis square;
            hold on;

            if iC == 1; title(c{iP}); end
            if iC == 2; xlabel('Azimuth ($^{\circ}$)'); end
            if iP == 1; ylabel('Elevation ($^{\circ}$)'); end

            % Define ticks and limits
            ylim([-50 50]);
            xlim([-50 50]);
            pause(.1);

            for iD = 1:NDUR
            % Run over number of durations

               Di = NDUR+1-iD;   % flip directions
               
               % Select predictor
               switch iP
                  case 1
                     predictor  = S(iS).condition(iC).model_data(Di).Tr;
                  case 2
                     predictor  = S(iS).condition(iC).model_data(Di).Cs;
                  case 3
                     predictor  = S(iS).condition(iC).model_data(Di).Hc;
                  case 4
                     predictor  = S(iS).condition(iC).model_data(Di).Eh;
               end
              
               x = predictor(:,1);
               y = predictor(:,2);
               
               scatter(x,y,6,'MarkerEdgeColor',CDUR(Di,:),'MarkerFaceColor',CDUR(Di,:),'MarkerFaceAlpha',0.6,'Tag','Fixed');
            end       
         end
      end
   end
   pb_nicegraph('def',1);
end



% %% Retinal Slip
% 
% 
% for iS = 1:NSUBJ
% 
%    % Make figure
%    cfn = pb_newfig(cfn);
%    sgtitle('Retinal slip')
% 
%    cnt = 0;
%    for iC = 1:NCOND
%    % Run for condition (head free / fixed)
% 
%       for iD = 1:NDUR
%       % Run for subjects (s001/003/004)
%          cnt = cnt+1;
% 
%          if iC <= length(S(iS).condition)    
%          % Check if data exists
% 
%             % Make subplot
%             subplot(NCOND,NDUR,cnt);
%             
%             if iC == 1; title([num2str(durs(iD)) ' ms']); end
%             if iC == length(S(iS).condition); xlabel('Position ($^{\circ}$)'); end
%             
%             hold on;
%             axis square;
%             xlim([-20 20]);
%             ylim([-20 20]);
%             
%             x     = S(iS).condition(iC).model_data(iD).Rx;
%             y     = S(iS).condition(iC).model_data(iD).Ry;
%  
%             left  = S(iS).condition(iC).model_data(iD).sC < 0;
%             
%             h = [];
%             for iR = 1:length(x)
%                collie = CDUR(iD,:);
%                if left(iR); collie = CDUR(iD,:)/2; end
%                h(iR) = plot(x{iR},y{iR},'color',collie,'linewidth',2,'Tag','Fixed');
%             end
%          end
%       end
%    end
%    pb_nicegraph;
% end
% 

%%

P(1).pred(1).value = [];
P(1).pred(2).value = [];
P(1).pred(3).value = [];
P(1).pred(4).value = [];
P(2).pred(1).value = [];
P(2).pred(2).value = [];
P(2).pred(3).value = [];
P(2).pred(4).value = [];
P(3).pred(1).value = [];
P(3).pred(2).value = [];
P(3).pred(3).value = [];
P(3).pred(4).value = [];


for iS = 1:NSUBJ
   for iC = 1:NCOND
      for iD = 1:NDUR
         if iC <= length(S(iS).condition)
            
            % select data
            rt       = S(iS).condition(iC).model_data(iD).RT;
            t        = abs(S(iS).condition(iC).model_data(iD).G(:,2) - S(iS).condition(iC).model_data(iD).Tr(:,2));

            sel_D    = rt>SEL_D(1) & rt< SEL_D(2);
            sel_T    = t < SEL_T;
            sel      = sel_D & sel_T;

            P(iS).pred(1).value     = [P(iS).pred(1).value; S(iS).condition(iC).model_data(iD).G(sel,1)];
            P(iS).pred(2).value     = [P(iS).pred(2).value; S(iS).condition(iC).model_data(iD).Tr(sel,1)];
            P(iS).pred(3).value     = [P(iS).pred(3).value; S(iS).condition(iC).model_data(iD).Cs(sel,1)];
            P(iS).pred(4).value     = [P(iS).pred(4).value; S(iS).condition(iC).model_data(iD).Eh(sel,1)];
            
         end
      end
   end
end


%%

NPRED = 4;

CSUB = pb_selectcolor(3,2);

cfn = pb_newfig(cfn); 
sgtitle('Interactions');
c_pred = {'G','Tr','Cs','Eh'};

cnt = 0;
for iAx = 1:NPRED
   % for all predictors
   for iAy = 1:NPRED
      % for all predictors
      
      cnt = cnt+1;
      subplot(NPRED,NPRED,cnt)
      if iAx == 1; title(c_pred{iAy}); end
      if iAy == 1; ylabel(c_pred{iAx}); end
            
      axis square;
      hold on;
      
      if ~(mod(cnt,NPRED+1) == 1)
         % target response
         for iS = 1:NSUBJ
            h = pb_regplot(P(iS).pred(iAy).value, P(iS).pred(iAx).value,'color',CSUB(iS,:),'marker','.','alpha',0.2,'size',5);
         end

         xlim([-50 50]);
         ylim([-50 50]);
      else
         % histogram
         if iC == 1; title(c{iP}); end
         for iS = 1:NSUBJ
            histogram(P(iS).pred(iAx).value,'BinWidth',5);        
         end
         xlim([-100 100]);
      end
   end
end

pb_nicegraph;

