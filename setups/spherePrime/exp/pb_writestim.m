function pb_writestim(Modality,fid, AUD, VIS)
% WRITESND(FID,SND,X,Y,ID,INT,EVENTON,ONSET)
%
% Write a (Combined) SND/LED-stimulus line in an exp-file with file identifier FID.
%
% See also WRITESND, WRITELED, GENEXP_DDS

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
    

    for i = 1:length(AUD)
        switch Modality
            case 1 % A
                fprintf(fid,'%s\t%d\t%d\t%d\t%.1f\t%d\t%d\n',AUD(i).SND,AUD(i).X,AUD(i).Y,AUD(i).ID,AUD(i).Int,AUD(i).EventOn,AUD(i).Onset);
            case 2 % V
                fprintf(fid,'%s\t%d\t%d\t \t%d\t%d\t%d\t%d\t%d\n',VIS(i).LED,VIS(i).X,VIS(i).Y,VIS(i).Int,VIS(i).EventOn,VIS(i).Onset,VIS(i).EventOff,VIS(i).Offset);
            case 3 % AV
                fprintf(fid,'%s\t%d\t%d\t%d\t%.1f\t%d\t%d\n',AUD(i).SND,AUD(i).X,AUD(i).Y,AUD(i).ID,AUD(i).Int,AUD(i).EventOn,AUD(i).Onset);
                fprintf(fid,'%s\t%d\t%d\t \t%d\t%d\t%d\t%d\t%d\n',VIS(i).LED,VIS(i).X,VIS(i).Y,VIS(i).Int,VIS(i).EventOn,VIS(i).Onset,VIS(i).EventOff,VIS(i).Offset);
        end
    end
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

