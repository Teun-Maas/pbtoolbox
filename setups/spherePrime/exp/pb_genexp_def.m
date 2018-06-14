function pb_genexp_def
% PB_GENEXP_DEF
% 
%  Goal:                                                                  
%  This script will guide you (semi-)automated through the process of       
%  writing and saving an experiment.  
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

    % Initialization
    home
    close all
    clear hidden
    clc; pause(0.05);
    
    disp('   >> GENERATING EXPERIMENT <<')

    cd('/Users/jjheckman/Documents/Data/PhD/Experiments/') % default data directory
    cdir = uigetdir(); if cdir ~= 0; cd(cdir); end
    
    disp([newline '   Experiment directory:         "' cdir '/"'])

    % Variables   
    minled      = 300;
    maxled      = 800;
    
    %expfile     = 'def_exp'; 
    expfile     = input('   Experiment name:              ','s');
    datdir      = 'JJH\';
    
    minsnd      = 200; % 200 ms gap (total darkness and silence) for optimal OPN inhibition...
    maxsnd      = 200;

    % Desired azimuth and elevation
    des_az		= -45:30:45;
    des_el		= -45:30:45;
    [des_az,des_el] = meshgrid(des_az,des_el);
    des_az		= des_az(:);
    des_el		= des_el(:);
    sel			= (abs(des_az)+abs(des_el))<=90 & des_el>-60; 
    des_az		= des_az(sel);
    des_el		= des_el(sel);

    % Actual azimuth and elevation
    cfg             = spherelookup; % sphere positions
    channel         = cfg.interpolant(des_az',des_el');
    X               = cfg.lookup(channel+1,5);
    Y               = cfg.lookup(channel+1,6);

    % Conditions
    int                 = 65; % We only one intensity (approx. 65 dB)
    freq                = 1; % We only use broadband sounds
    modality            = [1 2 3]; % A, V, AV
    dur                 = [1 2 3 4];
    rdur                = [4 6 10 30]; 

    [X,~,~]             = ndgrid(X,modality,dur);
    [Y,modality,dur]    = ndgrid(Y,modality,dur);
    X                   = X(:);
    Y                   = Y(:);
    modality            = modality(:);
    dur                 = dur(:);

    % Filtering 0,0 starting locations
    Xctr = X;
    Yctr = Y;
    a = 0;
    for i = 1:length(X)
        if X(i) == 0 && Y(i) == 0
            Xctr(i-a) = [];
            Yctr(i-a) = [];
            a = a+1;
        end
    end
    X = Xctr;
    Y = Yctr;
    clear Xctr Yctr a;

    % Creating matrix of all possible combinations
    Stimuli=zeros(length(X),6);
    for n=1:length(X)
        Stimuli(n,1)=X(n);
        Stimuli(n,2)=Y(n);
        Stimuli(n,5)=dur(n);
        Stimuli(n,6)=modality(n);
    end

    % Desired azimuth and elevation for second target
    des_az2             = -45:30:45;
    des_el2             = -45:30:45;
    [des_az2,des_el2]   = meshgrid(des_az2,des_el2);
    des_az2             = des_az2(:);
    des_el2             = des_el2(:);
    sel2                = (abs(des_az2)+abs(des_el2))<=60;
    des_az2             = des_az2(sel2);
    des_el2             = des_el2(sel2);
    nloc2               = numel(des_az2);

    % Creating X2 and Y2
    channel2	= cfg.interpolant(des_az2',des_el2');
    X2          = cfg.lookup(channel2+1,5);
    Y2          = cfg.lookup(channel2+1,6);

    % Adding X2 and Y2 to the first list
    X2			= X2(:);
    Y2			= Y2(:);
    Stimuli2    = zeros(length(Stimuli)*nloc2,6);
    for n=1:length(Stimuli)
        for m=1:nloc2
            Stimuli2((n-1)*nloc2+m,1)=Stimuli(n,1);
            Stimuli2((n-1)*nloc2+m,2)=Stimuli(n,2);
            Stimuli2((n-1)*nloc2+m,5)=Stimuli(n,5);
            Stimuli2((n-1)*nloc2+m,6)=Stimuli(n,6);
            Stimuli2((n-1)*nloc2+m,3)=X2(m)+Stimuli(n,1);
            Stimuli2((n-1)*nloc2+m,4)=Y2(m)+Stimuli(n,2);
        end
    end

    % Filtering unwanted locations    
    for n = length(Stimuli2):-1:1 
        if abs(Stimuli2(n,3))>60
            Stimuli2(n,:) = [];
        elseif Stimuli2(n,4)>60
            Stimuli2(n,:) = [];
        elseif Stimuli2(n,4)<-50
            Stimuli2(n,:) = [];
        elseif (abs(Stimuli2(n,3))+abs(Stimuli2(n,4)))>90
            Stimuli2(n,:) = [];
        end 
    end

    % Making real locations of the X2 and Y2
    channel         = cfg.interpolant(Stimuli2(:,3)',Stimuli2(:,4)');
    Stimuli2(:,3)	= cfg.lookup(channel+1,5);
    Stimuli2(:,4)	= cfg.lookup(channel+1,6);

    % Filtering some more unwanted locations
    for n=length(Stimuli2):-1:1
        if Stimuli2(n,3) == 0 && Stimuli2(n,4) == 0
            Stimuli2(n,:) = [];
        elseif Stimuli2(n,3) == Stimuli2(n,1) && Stimuli2(n,4) == Stimuli2(n,2)
            Stimuli2(n,:) = [];
        end
    end

    % Creating a Location control
    % When two sounds are played on the same RP2, they won't play.
    % Therefor, we must check and sometimes switch this. Here, we create
    % matrices that are going to help us to check this. LocList1 will be
    % for the first target and LocList2 for every second target.

    LocList1 = [Stimuli2(1,1) Stimuli2(1,2)];
    cntr = 0;
    
    for n = 1:length(Stimuli2)
        for m = 1:length(LocList1(:,1))
            if Stimuli2(n,1) == LocList1(m,1) && Stimuli2(n,2) == LocList1(m,2)
                cntr=1;
            end
        end
        if cntr == 0
            LocList1 = [LocList1; Stimuli2(n,1:2)];
        end
        cntr = 0;
    end

    LocList2 = [Stimuli2(1,3) Stimuli2(1,4)];
    cntr = 0;
    
    for n = 1:length(Stimuli2)
        for m = 1:length(LocList2(:,1))
            if Stimuli2(n,3) == LocList2(m,1) && Stimuli2(n,4) == LocList2(m,2)
                cntr=1;
            end
        end
        if cntr == 0
            LocList2 = [LocList2; Stimuli2(n,3:4)];
        end
        cntr = 0;
    end

    % Combining with cfg.lookup to add multiplex and RP2 numbers
    % Now we add the RP2 and multiplex numbers to the LocList matrix. Row 3
    % will be the RP2 number and row 4 the multiplex number

    LocList1 = [LocList1 zeros(length(LocList1),2)];
    for n = 1:length(cfg.lookup)
        for m = 1:length(LocList1)
            if LocList1(m,1) == cfg.lookup(n,5) && LocList1(m,2) == cfg.lookup(n,6)
                LocList1(m,3) = cfg.lookup(n,2);
                LocList1(m,4) = cfg.lookup(n,3);
            end
        end
    end

    LocList2 = [LocList2 zeros(length(LocList2),2)];
    for n = 1:length(cfg.lookup)
        for m = 1:length(LocList2)
            if LocList2(m,1) == cfg.lookup(n,5) && LocList2(m,2) == cfg.lookup(n,6)
                LocList2(m,3) = cfg.lookup(n,2);
                LocList2(m,4) = cfg.lookup(n,3);
            end
        end
    end

    % Creating the change list
    % The change list will list all possible first and second target
    % combinations and give a new second target for that specific combination.

    ChaList=zeros(length(LocList1)*length(LocList2),10);
    for n = 1:length(LocList1)
        for m = 1:length(LocList2)
            ChaList((n-1)*length(LocList2)+m,1:4) = LocList1(n,1:4);
            ChaList((n-1)*length(LocList2)+m,5:8) = LocList2(m,1:4);
        end
    end
    
    Delta = ones(length(cfg.lookup), length(ChaList))*1000;
    for n = 1:length(ChaList)
        %Here, we have a function that finds a new target on a different
        %RP2 as close to the previous target as possible.
        if ChaList(n,3) == ChaList(n,7) %Use this to find matching RP2's
            for m = 1:length(cfg.lookup)
                if ChaList(n,7) == cfg.lookup(m,3)
                else
                    Xcntr       = abs(cfg.lookup(m,5)-ChaList(n,5));
                    Ycntr       = abs(cfg.lookup(m,6)-ChaList(n,6));
                    Delta(m,n)  = sqrt(Xcntr^2+Ycntr^2);
                end
            end
            [~,Index]       = min(Delta(:,n));
            ChaList(n,9:10) = cfg.lookup(Index,5:6);
        else
            ChaList(n,9:10) = ChaList(n,5:6);
        end
%         if ChaList(n,4)==ChaList(n,8) 
%             %Use this to find matching multiplexes
%             %Here, we have a function that finds a new target on a different
%             %multiplex as close to the previous target as possible.
%             for m=1:length(cfg.lookup)
%                 if ChaList(n,4)==cfg.lookup(m,3)
%                 else
%                     Xcntr=abs(cfg.lookup(m,5)-ChaList(n,5));
%                     Ycntr=abs(cfg.lookup(m,6)-ChaList(n,6));
%                     Delta(m,n)=sqrt(Xcntr^2+Ycntr^2);
%                 end
%             end
%             [~,Index]=min(Delta(:,n));
%             ChaList(n,9:10) = cfg.lookup(Index,5:6);
%         else
%             ChaList(n,9:10) = ChaList(n,5:6);
%         end
    end

    % Using the change list to alter the locations of the second targets
    % We check every trial and replace every faulty combination of first and
    % second targets by a correct one from the change list. We only need to
    % replace targets with modality 1 of 3.
    for n = 1:length(Stimuli2)
        if (Stimuli2(n,6) == 1 || Stimuli2(n,6) == 3)
            for m = 1:length(ChaList)
                if Stimuli2(n,1:4) == ChaList(m,[1 2 5 6])
                    Stimuli2(n,3:4) = ChaList(m,[9 10]);
                end
            end
        end
    end

    % Get random timings and sound files
    snd     = zeros(length(Stimuli2),1);
    snd2    = zeros(length(Stimuli2),1);
    ledon   = zeros(length(Stimuli2),1);
    sndon   = zeros(length(Stimuli2),1);
    
    for n = 1:length(Stimuli2)
        snd(n)      = rndval(Stimuli2(n,5)*100,Stimuli2(n,5)*100+99,1);
        snd2(n)     = rndval(Stimuli2(n,5)*100,Stimuli2(n,5)*100+99,1);
        ledon(n)    = rndval(minled,maxled,1);
        sndon(n)    = rndval(minsnd,maxsnd,1);
    end

    % Extracting everything from the Stimuli2 matrix
    X           = Stimuli2(:,1);
    Y           = Stimuli2(:,2);
    X2          = Stimuli2(:,3);
    Y2          = Stimuli2(:,4);
    dur         = Stimuli2(:,5);
    modality    = Stimuli2(:,6);
    int         = ones(length(Stimuli2),1)*int;
    freq        = ones(length(Stimuli2),1)*freq;
    

    
    % Include control trials
    rtrials     = length(X);
    ctrials     = ceil(rtrials/5);
    rperm       = randperm(length(X),ctrials);
    
    for iPerm = 1:ctrials
        X(end+1)        = X(rperm(iPerm));
        Y(end+1)        = Y(rperm(iPerm));
        X2(end+1)       = X2(rperm(iPerm));
        Y2(end+1)       = Y2(rperm(iPerm));
        dur(end+1)      = dur(rperm(iPerm));
        modality(end+1) = modality(rperm(iPerm));
        int(end+1)      = int((rperm(iPerm)));
        freq(end+1)     = freq(rperm(iPerm));
        snd(end+1)      = snd(rperm(iPerm));
        snd2(end+1)     = snd(rperm(iPerm));
        ledon(end+1)    = ledon(rperm(iPerm));
        sndon(end+1)    = sndon(rperm(iPerm));
    end
    
    
    %% Randomizing things
    
    rnd				= randperm(length(X));
    rpermlist       = find(rnd>rtrials);

    X				= round(X(rnd));
    Y				= round(Y(rnd));
    X2				= round(X2(rnd));
    Y2				= round(Y2(rnd));
    ledon			= ledon(rnd);
    sndon			= sndon(rnd);
    modality        = modality(rnd);
    dur             = dur(rnd);
    dur             = rdur(dur);
    snd             = snd(rnd);
    snd2            = snd2(rnd);

    %% Save data somewhere
    
    writeexp(expfile,datdir,X,Y,X2,Y2,snd,snd2,int,ledon,sndon,modality,dur,rpermlist); 

end

function writeexp(expfile,datdir,theta,phi,theta2,phi2,snd,snd2,int,ledon,sndon,modality,dur,rpermlist)
% Save known trial-configurations in exp-file

    ntrials         = numel(theta);
    blocklength     = 125;
    blocks          = ceil(ntrials/blocklength);
    blocktrial      = ones(1,blocks) .* blocklength;
    blocktrial(end) = mod(ntrials,blocklength);

    %% Dipslays

    disp([newline '   Number of trials:             ' num2str(ntrials)])
    disp(['   Number of blocks:             ' num2str(blocks)])
    disp(['   Number of trials per block:   ' num2str(blocktrial) newline])

    %% Header of exp-file
    
    ITI			= [0 0];  % useless, but required in header
    Rep			= 1; % We need 0 repeats, so Rep is set to 1
    Rnd			= 0; % We randomized ourselves
    Mtr			= 'n'; % the motor should be on

    %% Body of exp-file
    % Create a trial
    disp(['   Writing experiments ...' newline]);
    
    for iBlck = 1:blocks

        efile		= fcheckext([expfile '_' num2str(iBlck)],'.exp');
        fid         = fopen(efile,'w'); 

        writeheader(fid,datdir,ITI,blocktrial(iBlck),Rep,Rnd,Mtr,'Lab',2);

        for iTrl = 1:blocktrial(iBlck)
            
            Trl = ((iBlck-1)*blocklength)+iTrl;

            AUD = []; VIS = [];

            AUD(1).SND = 'SND'; AUD(1).X = theta(Trl); AUD(1).Y = phi(Trl); AUD(1).ID = snd(Trl); AUD(1).Int = int(Trl); AUD(1).EventOn = 1; AUD(1).Onset = ledon(Trl)+sndon(Trl);
            AUD(2).SND = 'SND'; AUD(2).X = theta2(Trl); AUD(2).Y = phi2(Trl); AUD(2).ID = snd2(Trl); AUD(2).Int = int(Trl); AUD(2).EventOn = 2; AUD(2).Onset = 0;
            VIS(1).LED = 'LED'; VIS(1).X = theta(Trl); VIS(1).Y = phi(Trl); VIS(1).Int = 5; VIS(1).EventOn = 1; VIS(1).Onset = ledon(Trl)+sndon(Trl); VIS(1).EventOff = 1; VIS(1).Offset = ledon(Trl)+sndon(Trl)+dur(Trl);
            VIS(2).LED = 'LED'; VIS(2).X = theta2(Trl); VIS(2).Y = phi2(Trl); VIS(2).Int = 5; VIS(2).EventOn = 2; VIS(2).Onset = 0; VIS(2).EventOff = 2; VIS(2).Offset = dur(Trl);
            
            % Make sure control trials have only 1 event
            if ~isempty(find(rpermlist==Trl, 1))
                AUD(2).EventOn = 1;
                AUD(2).Onset = ledon(Trl)+sndon(Trl)+150;
                VIS(2).EventOn = 1; 
                VIS(2).Onset = ledon(Trl)+sndon(Trl)+150; 
                VIS(2).EventOff = 1; 
                VIS(2).Offset = ledon(Trl)+sndon(Trl)+dur(Trl)+150;
            end
            
            % Write expfile
            writetrl(fid,iTrl);                             % Trial number
            writeled(fid,'LED',0,0,5,0,0,1,ledon(Trl));     % Fixation LED
            writetrg(fid,1,2,0,0,1);                        % Button trigger after LED has been fixated
            writeacq(fid,1,ledon(Trl));                     % Data Acquisition immediately after fixation LED exinction
            pb_writestim(modality(Trl),fid,AUD,VIS);

        end
        fclose(fid);
        disp(['      >> ' efile]);
    end
    disp([newline '   ... expfiles generated.'])
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
