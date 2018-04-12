function Stim = pb_stim2MSstim(Stim)
% STIM = STIM2MSSTIM(FID,Stim)
% 
% Converst Stim Variable into a Multisensory Stim variable, i.e. it reads
% of the original .exp fid, combined with the Stim variable produced by the
% pa_sac2mat function and outputs a new Stim variable. Note that 'Attribute' 
% (column 20, see pa_index) now reads of the stimulus duration in ms.
%
% see also MSINDEX, SUPERSAC

% 2018 Jesse J. Heckman
% e-mail: j.heckman@donders.ru.nl
    
    tempStim = [];
    l = length(Stim); 
    ntrials = Stim(l,1);
    stimDur = pb_stimlog(3.8,80,6);
    
    for i = 1:ntrials
        h = find(Stim(:,1)==i);
        
        for j = 1:3
            tempStim = [tempStim; Stim(h(j),:)];
        end

        switch length(h)
            case 5
                for rep = 1:2
                    tempStim = [tempStim; Stim((h(3+rep)),:)];
                    tempStim(end,2) = 3;
                    if tempStim(end,3) == 0
                        tempStim(end,3) = 1;
                    end
                end
            case 7
                for rep = 1:2
                    tempStim = [tempStim; Stim(h(4+((rep-1)*2)),:)];
                    tempStim(end,2) = 3+rep;
                    tempStim(end,3) = 3;
                end     
            otherwise
                error('Not enough parameters within trial.')
        end
        if tempStim(end,end) == 0
            tempStim(end,end) = tempStim(end,9)-tempStim(end,8);
        else
            tempStim(end,end) = stimDur(floor(tempStim(end,end)/100));
        end
    end
    Stim = tempStim;
end


