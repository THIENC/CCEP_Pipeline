%% Path
clear
cd('E:\5.CCEP\1.CCEP_Results_Final')

%% Nine network average ignoring NaNs
Folders = dir(pwd);
Folders = Folders(3:2:end);
Folders = {Folders.name}';

% %% Zscore and mean
% for i = 1:25
%     cd(Folders{i})
%     ChannelsSorted = [];
%     M_greySorted1 = [];
%     % Load information
%     load('PTXXX_Matrix_grey_Final_Sorted.mat')
%     load('PTXXX_Matrix_Channels_Final_Sorted.mat')
%     
%     % Normalization within subject
%     zscoreM = (M_greySorted1 - nanmean(M_greySorted1))/nanstd(M_greySorted1(:));
%     
%     % Assignvalues
%     EZInd  = find([ChannelsSorted.tag] == 1);
%     PZInd  = find([ChannelsSorted.tag] == 2);
%     NIZInd = find([ChannelsSorted.tag] == 3);
%     
%     EZ2EZ(i,1)  = nanmean(nanmean(zscoreM(EZInd,EZInd)));
%     EZ2PZ(i,1)  = nanmean(nanmean(zscoreM(EZInd,PZInd)));
%     EZ2NIZ(i,1) = nanmean(nanmean(zscoreM(EZInd,NIZInd)));
%     
%     PZ2EZ(i,1)  = nanmean(nanmean(zscoreM(PZInd,EZInd)));
%     PZ2PZ(i,1)  = nanmean(nanmean(zscoreM(PZInd,PZInd)));
%     PZ2NIZ(i,1) = nanmean(nanmean(zscoreM(PZInd,NIZInd)));
%     
%     NIZ2EZ(i,1)  = nanmean(nanmean(zscoreM(NIZInd,EZInd)));
%     NIZ2PZ(i,1)  = nanmean(nanmean(zscoreM(NIZInd,PZInd)));
%     NIZ2NIZ(i,1) = nanmean(nanmean(zscoreM(NIZInd,NIZInd)));
%     cd ..
%     
% end

%% Mean and zscore
for i = 1:25
    cd(Folders{i})
    ChannelsSorted = [];
    M_greySorted1 = [];
    % Load information
    load('PTXXX_Matrix_grey_Final_Sorted.mat')
    load('PTXXX_Matrix_Channels_Final_Sorted.mat')
    
    % Normalization within subject
    % zscoreM = (M_greySorted1 - nanmean(M_greySorted1))/nanstd(M_greySorted1(:));
    
    % Assignvalues
    EZInd  = find([ChannelsSorted.tag] == 1);
    PZInd  = find([ChannelsSorted.tag] == 2);
    NIZInd = find([ChannelsSorted.tag] == 3);
    
    EZ2EZ(i,1)  = nanmean(nanmean(M_greySorted1(EZInd,EZInd)));
    EZ2PZ(i,1)  = nanmean(nanmean(M_greySorted1(EZInd,PZInd)));
    EZ2NIZ(i,1) = nanmean(nanmean(M_greySorted1(EZInd,NIZInd)));
    
    PZ2EZ(i,1)  = nanmean(nanmean(M_greySorted1(PZInd,EZInd)));
    PZ2PZ(i,1)  = nanmean(nanmean(M_greySorted1(PZInd,PZInd)));
    PZ2NIZ(i,1) = nanmean(nanmean(M_greySorted1(PZInd,NIZInd)));
    
    NIZ2EZ(i,1)  = nanmean(nanmean(M_greySorted1(NIZInd,EZInd)));
    NIZ2PZ(i,1)  = nanmean(nanmean(M_greySorted1(NIZInd,PZInd)));
    NIZ2NIZ(i,1) = nanmean(nanmean(M_greySorted1(NIZInd,NIZInd)));

    ZscoreTemp = [];
    ZscoreTemp = zscore([EZ2EZ(i,1),EZ2PZ(i,1),EZ2NIZ(i,1),...
                         PZ2EZ(i,1),PZ2PZ(i,1),PZ2NIZ(i,1),...
                         NIZ2EZ(i,1),NIZ2PZ(i,1),NIZ2NIZ(i,1)]);
    EZ2EZ(i,1)   = ZscoreTemp(1);
    EZ2PZ(i,1)   = ZscoreTemp(2);
    EZ2NIZ(i,1)  = ZscoreTemp(3);
    PZ2EZ(i,1)   = ZscoreTemp(4);
    PZ2PZ(i,1)   = ZscoreTemp(5);
    PZ2NIZ(i,1)  = ZscoreTemp(6);
    NIZ2EZ(i,1)  = ZscoreTemp(7);
    NIZ2PZ(i,1)  = ZscoreTemp(8);
    NIZ2NIZ(i,1) = ZscoreTemp(9);

    cd ..
end
%% Visulize the final data
figure
boxplot([EZ2EZ,EZ2PZ,EZ2NIZ,PZ2EZ,PZ2PZ,PZ2NIZ,NIZ2EZ,NIZ2PZ,NIZ2NIZ])
h = lillietest(EZ2EZ)

%% Stimulation and recording
% Stimulation
EZStim    = mean([EZ2EZ,EZ2PZ,EZ2NIZ],2);
PZStim    = mean([PZ2EZ,PZ2PZ,PZ2NIZ],2);
NIZStim   = mean([NIZ2EZ,NIZ2PZ,NIZ2NIZ],2);

figure
boxplot([EZStim,PZStim,NIZStim])
[h,p] = ttest2(EZStim,PZStim)
title('Stimulation')
h = lillietest(EZStim)
% Recording
EZRecord  = mean([EZ2EZ,PZ2EZ,NIZ2EZ],2);
PZRecord  = mean([EZ2PZ,PZ2PZ,NIZ2PZ],2);
NIZRecord = mean([EZ2NIZ,PZ2NIZ,NIZ2NIZ],2);

figure
boxplot([EZRecord,PZRecord,NIZRecord])
title('Recording')
[h,p] = ttest2(EZRecord,NIZRecord);

%%


