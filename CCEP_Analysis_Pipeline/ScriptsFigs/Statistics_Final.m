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
median(EZStim)
[min(EZStim) max(EZStim)]

median(PZStim)
[min(PZStim) max(PZStim)]

median(NIZStim)
[min(NIZStim) max(NIZStim)]

%
median(EZRecord)
[min(EZRecord) max(EZRecord)]

median(PZRecord)
[min(PZRecord) max(PZRecord)]

median(NIZRecord)
[min(NIZRecord) max(NIZRecord)]

%% Prognostic analysis
Outcome = [1 1 1 2 4 1 1 2 1 2 3 1 1 1 1 1 1 3 2 1 1 1 1 1 1 ]';

figure
scatter(EZStim,Outcome)
[rho,pval] = corr(EZStim,Outcome)
figure
scatter(PZStim,Outcome)
[rho,pval] = corr(PZStim,Outcome)
figure
scatter(NIZStim,Outcome)
[rho,pval] = corr(NIZStim,Outcome)



figure
scatter(EZRecord,Outcome)
[rho,pval] = corr(EZRecord,Outcome)
figure
scatter(PZRecord,Outcome)
[rho,pval] = corr(PZRecord,Outcome)
figure
scatter(NIZRecord,Outcome)

[rho,pval] = corr(NIZRecord,Outcome)

%%%%%%%%%%% Binary outcome
OutcomeBi = [Outcome ==1];

figure
scatter(EZStim,OutcomeBi)
[rho,pval] = corr(EZStim,OutcomeBi)
figure
scatter(PZStim,OutcomeBi)
[rho,pval] = corr(PZStim,OutcomeBi)
figure
scatter(NIZStim,OutcomeBi)
[rho,pval] = corr(NIZStim,OutcomeBi)

%%%%%%%%%%%%%%%%%%%%%%%
median(EZ2EZ(OutcomeBi))
[max(EZ2EZ(OutcomeBi)) min(EZ2EZ(OutcomeBi))]

median(EZ2EZ(~OutcomeBi))
[max(EZ2EZ(~OutcomeBi)) min(EZ2EZ(~OutcomeBi))]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
scatter(EZRecord,OutcomeBi)
[rho,pval] = corr(EZRecord,OutcomeBi)
figure
scatter(PZRecord,OutcomeBi)
[rho,pval] = corr(PZRecord,OutcomeBi)
figure
scatter(NIZRecord,OutcomeBi)
[rho,pval] = corr(NIZRecord,OutcomeBi)


% % Logistic regression
% [B,dev,stats] = mnrfit([EZStim PZStim],categorical(OutcomeBi))


p = ranksum(mean([EZStim(OutcomeBi) PZStim(OutcomeBi)],2),mean([EZStim(~OutcomeBi) PZStim(~OutcomeBi)],2))

p = ranksum(mean([EZRecord(OutcomeBi) PZRecord(OutcomeBi)],2),mean([EZRecord(~OutcomeBi) PZRecord(~OutcomeBi)],2))

mean(mean([EZRecord(OutcomeBi) PZRecord(OutcomeBi)],2))
mean(mean([EZRecord(~OutcomeBi) PZRecord(~OutcomeBi)],2))


p1 = ranksum(EZStim(OutcomeBi),EZStim(~OutcomeBi))
p2 = ranksum(PZStim(OutcomeBi),PZStim(~OutcomeBi))
p3 = ranksum(NIZStim(OutcomeBi),NIZStim(~OutcomeBi))

p4 = ranksum(EZRecord(OutcomeBi),EZRecord(~OutcomeBi))
p5 = ranksum(PZRecord(OutcomeBi),PZRecord(~OutcomeBi))
p6 = ranksum(NIZRecord(OutcomeBi),NIZRecord(~OutcomeBi))

% EZ
p = ranksum(EZ2EZ(OutcomeBi),EZ2EZ(~OutcomeBi))
mean(EZ2EZ(OutcomeBi))
mean(EZ2EZ(~OutcomeBi))
p = ranksum(EZ2PZ(OutcomeBi),EZ2PZ(~OutcomeBi))

p = ranksum(EZ2NIZ(OutcomeBi),EZ2NIZ(~OutcomeBi))
mean(EZ2NIZ(OutcomeBi))
mean(EZ2NIZ(~OutcomeBi))
% PZ
p = ranksum(PZ2EZ(OutcomeBi),PZ2EZ(~OutcomeBi))

p = ranksum(PZ2PZ(OutcomeBi),PZ2PZ(~OutcomeBi))

p = ranksum(PZ2NIZ(OutcomeBi),PZ2NIZ(~OutcomeBi))

% NIZ
p = ranksum(NIZ2EZ(OutcomeBi),NIZ2EZ(~OutcomeBi))

p = ranksum(NIZ2PZ(OutcomeBi),NIZ2PZ(~OutcomeBi))

p = ranksum(NIZ2NIZ(OutcomeBi),NIZ2NIZ(~OutcomeBi))

%%% Write CSV file
% EZ2EZ ----------------------------------------
Stim_R_F = [];
Outputname = 'Prog_EZ2EZ.csv';
Stim_R_F = [EZ2EZ, OutcomeBi];
csvwrite(Outputname,Stim_R_F)
% EZ2PZ
Stim_R_F = [];
Outputname = 'Prog_EZ2PZ.csv';
Stim_R_F = [EZ2PZ, OutcomeBi];
csvwrite(Outputname,Stim_R_F)
% EZ2NIZ
Stim_R_F = [];
Outputname = 'Prog_EZ2NIZ.csv';
Stim_R_F = [EZ2NIZ, OutcomeBi];
csvwrite(Outputname,Stim_R_F)

% PZ2EZ ---------------------------------------
Stim_R_F = [];
Outputname = 'Prog_PZ2EZ.csv';
Stim_R_F = [PZ2EZ, OutcomeBi];
csvwrite(Outputname,Stim_R_F)
% PZ2PZ
Stim_R_F = [];
Outputname = 'Prog_PZ2PZ.csv';
Stim_R_F = [PZ2PZ, OutcomeBi];
csvwrite(Outputname,Stim_R_F)
% PZ2NIZ
Stim_R_F = [];
Outputname = 'Prog_PZ2NIZ.csv';
Stim_R_F = [PZ2NIZ, OutcomeBi];
csvwrite(Outputname,Stim_R_F)
% NIZ2EZ --------------------------------------
Stim_R_F = [];
Outputname = 'Prog_NIZ2EZ.csv';
Stim_R_F = [NIZ2EZ, OutcomeBi];
csvwrite(Outputname,Stim_R_F)
% NIZ2PZ
Stim_R_F = [];
Outputname = 'Prog_NIZ2PZ.csv';
Stim_R_F = [NIZ2PZ, OutcomeBi];
csvwrite(Outputname,Stim_R_F)
% NIZ2NIZ
Stim_R_F = [];
Outputname = 'Prog_NIZ2NIZ.csv';
Stim_R_F = [NIZ2NIZ, OutcomeBi];
csvwrite(Outputname,Stim_R_F)
%%
p2 = ranksum(PZStim(OutcomeBi),PZStim(~OutcomeBi))
p3 = ranksum(NIZStim(OutcomeBi),NIZStim(~OutcomeBi))

p4 = ranksum(EZRecord(OutcomeBi),EZRecord(~OutcomeBi))
p5 = ranksum(PZRecord(OutcomeBi),PZRecord(~OutcomeBi))
p6 = ranksum(NIZRecord(OutcomeBi),NIZRecord(~OutcomeBi))

