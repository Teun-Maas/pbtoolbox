function [h,b,r] = pb_regplot(X,Y)
% PB_REGPLOT()
%
% plots data, and linear regression.
%
% PA_REGPLOT(,Y) plots X vs Y, and performs linear regression on X and Y.
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
%% Initialization
    X       = X(:)';
    Y       = Y(:)';
    mrkr    = 'o';

%% Regression

    b = regstats(Y,X,'linear','beta');
    b = b.beta;
    gain                        = b(2);
    bias                        = b(1);
    r                           = corrcoef(X,Y); r = r(2);

%% Text

    if bias>0
        linstr                  = ['Y = ' num2str(gain,2) 'X + ' num2str(bias,2) ];
    elseif bias<=0
        linstr                  = ['Y = ' num2str(gain,2) 'X - ' num2str(abs(bias),2) ];
    end
    corrstr                     = ['r^2 = ' sprintf('%0.3f',r^2)];

%% Graphics

    h                           = plot(X, Y, ['k' mrkr]);
    hold on
    lsline;
    axis square;
    box off;
    %title(linstr)
    
    text(range(1)+10,range(4)-20,corrstr,'HorizontalAlignment','left')
    
    axxes = axis;
    plot(axxes([1 2]),gain*axxes([1 2])+bias,'k-','LineWidth',2);
 
end



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

