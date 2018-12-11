function pb_vWriteStim(fid,Modality,AUD,VIS)
% PB_VWRITESTIM(fid,Modality,AUD,VIS)
%
% PB_VWRITESTIM(fid,Modality,AUD,VIS)  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   stimsz = max([length(AUD) length(VIS)]);

    for i = 1:stimsz
        switch Modality
            case 1 % A
                fprintf(fid,'%s\t%d\t%d\t%d\t%f\t%d\t%d\n',AUD(i).SND,AUD(i).X,AUD(i).Y,AUD(i).ID,AUD(i).Int,AUD(i).EventOn,AUD(i).Onset);
            case 2 % V
                fprintf(fid,'%s\t%.0f\t%.0f\t \t%d\t%d\t%d\t%d\t%d\n',VIS(i).LED,VIS(i).X,VIS(i).Y,VIS(i).Int,VIS(i).EventOn,VIS(i).Onset,VIS(i).EventOff,VIS(i).Offset);
            case 3 % AV
                fprintf(fid,'%s\t%d\t%d\t%d\t%.1f\t%d\t%d\n',AUD(i).SND,AUD(i).X,AUD(i).Y,AUD(i).ID,AUD(i).Int,AUD(i).EventOn,AUD(i).Onset);
                fprintf(fid,'%s\t%.0f\t%.0f\t \t%d\t%d\t%d\t%d\t%d\n',VIS.LED,VIS.X,VIS(i).Y,VIS(i).Int,VIS(i).EventOn,VIS(i).Onset,VIS(i).EventOff,VIS(i).Offset);
        end
    end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

