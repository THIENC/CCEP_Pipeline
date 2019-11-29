clear
addpath(genpath('C:\Users\su_fe\Desktop\iELVis-master_BZ'))
%% Load the data you need
clear
%%%%%%%%%%%%
PatientID = 'PT060';
ResultsFolder = 'E:\5.CCEP\1.CCEP_Results_Final';


% Channel Inclusion
gLFile = [ResultsFolder filesep PatientID '_info\gL.mat'];
CoordinateFile = [ResultsFolder filesep PatientID '_info\gAC.mat'];

ChannelFile = [ResultsFolder filesep PatientID '\PTXXX_Matrix_Channels_Final_Sorted.mat'];
M_greyFile = [ResultsFolder filesep PatientID '\PTXXX_Matrix_grey_Final_Sorted.mat'];

cd([ResultsFolder filesep PatientID])
%% Load the data
load(gLFile)
load(CoordinateFile)
load(ChannelFile)
load(M_greyFile)
%% Calculate the distant matrix
ChannelIncludedSorted1 = {ChannelsSorted.chan}';

for i = 1:length(groupLabels)
    groupLabelsRaw{i,1} = groupLabels{i}(7:end);
end
switch PatientID
    case 'PT008'
        groupLabelsRaw2 = groupLabelsRaw;
        for i = 1:length(groupLabelsRaw)
            groupLabelsRaw2{i}(strfind(groupLabelsRaw{i},"'")) = [];
            groupLabelsRawNew{i,1} = lower(groupLabelsRaw2{i})
        end
        for j = 1:32
            groupLabelsRawNew{j}(2) = 'o';
        end
        for k = 1:length(ChannelIncludedSorted1)
            ChannelIncludedSorted1{k,1} = groupLabelsRaw{find(ismember(groupLabelsRawNew,ChannelIncludedSorted1{k}))}
        end
    case 'PT010'
        ChannelIncludedSorted1 = upper(ChannelIncludedSorted1);
    case 'PT014'
        ChannelIncludedSorted1 = upper(ChannelIncludedSorted1);
    case 'PT049'
        ChannelIncludedSorted1{1}(1:2) = 'aO';
        ChannelIncludedSorted1{7}(1:2) = 'aO';
        ChannelIncludedSorted1{8}(1:2) = 'aO';
        ChannelIncludedSorted1{9}(1:2) = 'aO';
        ChannelIncludedSorted1{10}(1:2) = 'aO';
        
        ChannelIncludedSorted1{11}(1:2) = 'pO';
        ChannelIncludedSorted1{12}(1:2) = 'pO';
        ChannelIncludedSorted1{13}(1:2) = 'pO';
        ChannelIncludedSorted1{14}(1:2) = 'pO';
    case 'PT057'
        ChannelIncludedSorted1{1}(1:2) = 'pO';
        ChannelIncludedSorted1{2}(1:2) = 'pO';
        ChannelIncludedSorted1{3}(1:2) = 'pO';
                
        ChannelIncludedSorted1{6}(1:2) = 'aO';
        ChannelIncludedSorted1{7}(1:2) = 'aO';
        ChannelIncludedSorted1{24}(1:2) = 'aO';
        ChannelIncludedSorted1{25}(1:2) = 'aO';
    case 'PT059'
        ChannelIncludedSorted1{19}(1:2) = 'pO';
        ChannelIncludedSorted1{20}(1:2) = 'pO';
        ChannelIncludedSorted1{21}(1:2) = 'pO';
%     case 'PT015'
%         EIIncludedSorted1 = EIIncludedSorted1/max(EIIncludedSorted1);
    case 'PT038'
        ChannelIncludedSorted1 = upper(ChannelIncludedSorted1);
end
%%

% Extract coordinates
for i = 1:length(ChannelsSorted)
   Indtemp = strcmp(groupLabelsRaw,ChannelIncludedSorted1{i});
   if max(Indtemp) < 1
       error([num2str(i) 'NotFound'])
   end
   Corrd(i,:) = groupAvgCoords(find(Indtemp),:);
end
% Construct matrix
for i = 1:length(ChannelsSorted)
    for j = 1:length(ChannelsSorted)
        CordM(i,j) = sqrt(sum([Corrd(i,:) - Corrd(j,:)].^2));
    end
end
    
% Filter matrix
% Make 
CordM_Final = CordM;
CordM_Final(isnan(M_greySorted1)) = NaN;

%% Calculate the distant for each patient for each group
EZInd  = find([ChannelsSorted.tag] == 1);
PZInd  = find([ChannelsSorted.tag] == 2);
NIZInd = find([ChannelsSorted.tag] == 3);
%
AvgDis.GroupEZ2EZ = nanmean(nanmean(CordM_Final(EZInd,EZInd)));
AvgDis.GroupEZ2PZ = nanmean(nanmean(CordM_Final(EZInd,PZInd)));
AvgDis.GroupEZ2NIZ = nanmean(nanmean(CordM_Final(EZInd,NIZInd)));
%
AvgDis.GroupPZ2EZ = nanmean(nanmean(CordM_Final(PZInd,EZInd)));
AvgDis.GroupPZ2PZ = nanmean(nanmean(CordM_Final(PZInd,PZInd)));
AvgDis.GroupPZ2NIZ = nanmean(nanmean(CordM_Final(PZInd,NIZInd)));
%
AvgDis.GroupNIZ2EZ = nanmean(nanmean(CordM_Final(NIZInd,EZInd)));
AvgDis.GroupNIZ2PZ = nanmean(nanmean(CordM_Final(NIZInd,PZInd)));
AvgDis.GroupNIZ2NIZ = nanmean(nanmean(CordM_Final(NIZInd,NIZInd)));

save('PTXXX_CoorM_Final_Sorted.mat','CordM_Final')
save('PTXXX_Avg_MNI_Dis.mat','AvgDis')

%% 













