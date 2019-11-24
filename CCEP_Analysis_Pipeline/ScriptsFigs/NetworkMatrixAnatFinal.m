%% Path
clear
addpath(genpath('C:\Users\su_fe\Desktop\iELVis-master_BZ'))
%% Pamameters
clear
%%%%%%%%%%%%
PatientID = 'PT055';
SideImp = 'l';
FSFolder = 'E:\5.CCEP\2.CCEP_Freesurfer';
ResultsFolder = 'E:\5.CCEP\1.CCEP_Results_Final';


% Channel Inclusion
gLFile = [ResultsFolder filesep PatientID '_info\gL.mat'];
flagFile = [ResultsFolder filesep PatientID '_info\flag.mat'];

ssFile = [ResultsFolder filesep PatientID '\PTXXX_ss.mat'];
M_greyFile = [ResultsFolder filesep PatientID '\PTXXX_Matrix_grey.mat'];

cd([ResultsFolder filesep PatientID])
% EIExcelFile = 'C:\Users\su_fe\Desktop\20190429_CCEP_Projects\Data\PT005\PT005_Onset_EI.xlsx';
% ChanFile = 'C:\Users\su_fe\Desktop\20190429_CCEP_Projects\Data\PT005\PTXXX_Channels.mat';

%% Create files for plot electrodes on the brain

global globalFsDir;
globalFsDir = FSFolder;

makeIniLocTxtFile(PatientID)
dykstraElecPjct(PatientID)

%% Load the data
load(gLFile)
load(flagFile)
load(ssFile)
load(M_greyFile)
%% Make derivatives
for i = 1:length(groupLabels)
    groupLabelsRaw{i,1} = groupLabels{i}(7:end);
end


% To load the included channel names using regular expression
for i = 1:length(ss)
    startIndex = min(find(isletter(ss(i).chan)));
    endIndex   = find(diff(isletter(ss(i).chan)) == 1);
    ChannelIncluded{i,1} = ss(i).chan(startIndex : endIndex);
    EIIncluded(i,1) = ss(i).EI;
    Categorization(i,1) = ss(i).tag;
end
groupLabelsRaw
ChannelIncluded
%% %%%%%%% Plot the matrix %%%%%%%%%%%%%%


% Set NaNs to the matrix
for i = 1:length(EIIncluded)
    % Identify electrode in one electrode shaft
    ElectrodeShaftName = ChannelIncluded{i}(isletter(ChannelIncluded{i}));
    ElecLetters = cellfun(@(x) isletter(x), ChannelIncluded, 'UniformOutput', false);
    for j = 1:length(ElecLetters)
        ChannelIncludedName{j,1} = ChannelIncluded{j}(ElecLetters{j});
    end
    ConnectElectrodes = find(strcmp(ChannelIncludedName,ElectrodeShaftName));
    for a = 1:length(ConnectElectrodes)
        M_grey(i,ConnectElectrodes(a)) = nan;
    end
end

% Manual check and label then save
% Plot for manual exclude extreme values
figure
imagesc(M_grey,'AlphaData',~isnan(M_grey))
colormap jet
grid on
xticks(1:size(M_grey,1))
yticks(1:size(M_grey,2))
xticklabels(ChannelIncluded)
yticklabels(ChannelIncluded)
title('Raw unsorted')

save('PTXXX_Matrix_grey_Final.mat','M_grey')
load('PTXXX_Matrix_grey_Final.mat')

%% 1st sort according to group
[CategorizationSorted, Index1] = sort(Categorization);
ChannelIncludedSorted1 = ChannelIncluded(Index1);
EIIncludedSorted1      = EIIncluded(Index1);
M_greySorted1          = M_grey(Index1,Index1);

% figure
% imagesc(M_greySorted1,'AlphaData',~isnan(M_greySorted1))
% colormap jet
% grid on
% xticks(1:size(M_greySorted1,1))
% yticks(1:size(M_greySorted1,2))
% xticklabels(ChannelIncludedSorted1)
% yticklabels(ChannelIncludedSorted1)
% title('First sorted')

save('PTXXX_Matrix_grey_Final_Sorted.mat','M_greySorted1')
load('PTXXX_Matrix_grey_Final_Sorted.mat')
for i = 1:length(EIIncludedSorted1)
    ChannelsSorted(i).EI = EIIncludedSorted1(i);
    ChannelsSorted(i).chan = ChannelIncludedSorted1{i};
    ChannelsSorted(i).tag = CategorizationSorted(i);
end
save('PTXXX_Matrix_Channels_Final_Sorted.mat','ChannelsSorted')
load('PTXXX_Matrix_Channels_Final_Sorted.mat')
% % 2nd sort according to EI value with each categorization
% for i = 1:3
%     CateNum = find(CategorizationSorted == i);
%     [EIIncludedSorted2(CateNum), IndexTemp] = sort(EIIncludedSorted1(CateNum),'descend');
%     ChannelIncludedtemp = ChannelIncludedSorted1(CateNum);
%     ChannelIncludedSorted2(CateNum) = ChannelIncludedtemp(IndexTemp);
%     M_greySortedTemp = M_greySorted1(CateNum,:);
%     M_greySorted2(CateNum,:) = M_greySortedTemp(IndexTemp,:);    
% end
% 
% figure
% imagesc(M_greySorted2,'AlphaData',~isnan(M_greySorted2))
% colormap jet
% grid on
% xticks(1:size(M_greySorted2,1))
% yticks(1:size(M_greySorted2,2))
% xticklabels(ChannelIncludedSorted2)
% yticklabels(ChannelIncludedSorted2)
% title('Second sorted')

%%
% Plot the final sorted matrix
figure
imagesc(M_greySorted1/max(M_greySorted1(:)),'AlphaData',~isnan(M_greySorted1))
colormap jet
grid on
colorbar
xticks(1.5:size(M_greySorted1,1)+0.5)
yticks(1.5:size(M_greySorted1,2)+0.5)
xticklabels(ChannelIncludedSorted1)
yticklabels(ChannelIncludedSorted1)
xtickangle(90)
set(gca,'TickLength',[0 0])

title([PatientID '-SortedMatrix-' 'EZ-PZ-NIZ'])

ax = gca;
ax.LineWidth = 3
axis square
% Make the seperating line for each group
hold on
%
line([0.5 size(M_greySorted1,1)+0.5],...
     [length(find(CategorizationSorted == 1)) + 0.5 length(find(CategorizationSorted == 1)) + 0.5],'LineWidth',3,'Color','k')
line([0.5 size(M_greySorted1,1)+0.5],...
     [length(find(CategorizationSorted ~= 3)) + 0.5 length(find(CategorizationSorted ~= 3)) + 0.5],'LineWidth',3,'Color','k')
%
line([length(find(CategorizationSorted == 1)) + 0.5 length(find(CategorizationSorted == 1)) + 0.5],...
     [0.5 size(M_greySorted1,1)+0.5],'LineWidth',3,'Color','k')
line([length(find(CategorizationSorted ~= 3)) + 0.5 length(find(CategorizationSorted ~= 3)) + 0.5],...
     [0.5 size(M_greySorted1,1)+0.5],'LineWidth',3,'Color','k')
set(gcf,'Position',[0 100 1000 1000])
print([PatientID '_SortedMatrix'],'-r600','-dpng')
close

 
%% %%%%%%%%%%%%% STIMULATION %%%%%%%%%%%%%%%%%%%%%%%
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
        
end

%% Stimulating
AbsMaxCCEP = max(M_greySorted1(:));


mkdir('Stimulation')
cd('Stimulation')
for i = 1:length(EIIncludedSorted1)
    pairs=[];
    ct=0;
    for a = 1:length(EIIncludedSorted1)
        % Remove some empty pairs
        if isnan(M_greySorted1(i,a))
            continue
        end
        ct = ct + 1;
        pairs{ct,1} = ChannelIncludedSorted1{i};
        pairs{ct,2} = ChannelIncludedSorted1{a};
        pairs{ct,3} = [0.6 0.6 0.6]; % RGB val
        pairs{ct,4} = upper(SideImp);
        pairs{ct,6} = M_greySorted1(i,a);
    end
    
    lineWidth = (max([pairs{:,6}])/AbsMaxCCEP) * 8;
    cfg = [];
    cfg.view = [SideImp 'omni'];
%     cfg.figId = 2;
    cfg.lineWidth = lineWidth;
    cfg.pairs = pairs;
    % Color the electrodes according to EI value
    cfg.elecColors = EIIncludedSorted1;
    cfg.elecColorScale = [0 1];
    cfg.elecNames = ChannelIncludedSorted1;
    % 
    cfg.elecShape = 'marker';
    cfg.edgeBlack='n';
    cfg.ignoreDepthElec='n';
    cfg.ignoreChans = setdiff(groupLabelsRaw,ChannelIncludedSorted1);
    cfg.opaqueness=0.03;
    cfg.showLabels='n';
    cfg.elecUnits='EI';
    cfg.title= [PatientID '-Stimulating-' ChannelIncludedSorted1{i} '-Group-' num2str(CategorizationSorted(i)) '-EI:' num2str(EIIncludedSorted1(i))];
    cfgOut = plotPialSurf(PatientID,cfg);
    set(gcf,'Position',[0 0 1920 1200])
    print(['Group-' num2str(CategorizationSorted(i)),'-', PatientID '-Stimulating-' ChannelIncludedSorted1{i}],'-r300','-dpng')
    
    close 
    
end
cd ..

%% %%%%%%%%%%%%% RECORDING %%%%%%%%%%%%%%%%%%%%%%%
mkdir('Recording')
cd('Recording')
for i = 1:length(EIIncludedSorted1)
    pairs=[];
    ct=0;
    for a = 1:length(EIIncludedSorted1)
        % Remove some empty pairs
        if isnan(M_greySorted1(a,i))
            continue
        end
        ct = ct + 1;
        pairs{ct,1} = ChannelIncludedSorted1{i};
        pairs{ct,2} = ChannelIncludedSorted1{a};
        pairs{ct,3} = [0.6 0.6 0.6]; % RGB val
        pairs{ct,4} = upper(SideImp);
        pairs{ct,6} = M_greySorted1(a,i);
    end
    
    lineWidth = (max([pairs{:,6}])/AbsMaxCCEP) * 8;
    cfg = [];
    cfg.view = [SideImp 'omni'];
    cfg.figId = 2;
    cfg.lineWidth = lineWidth;
    cfg.pairs = pairs;
    % Color the electrodes according to EI value
    cfg.elecColors = EIIncludedSorted1;
    cfg.elecColorScale = [0 1];
    cfg.elecNames = ChannelIncludedSorted1;
    % 
    cfg.elecShape = 'marker';
    cfg.edgeBlack='n';
    cfg.ignoreDepthElec='n';
    cfg.ignoreChans = setdiff(groupLabelsRaw,ChannelIncludedSorted1);
    cfg.opaqueness=0.03;
    cfg.showLabels='n';
    cfg.elecUnits='EI';
    cfg.title= [PatientID '-Recording-' ChannelIncludedSorted1{i} '-Group-' num2str(CategorizationSorted(i)) '-EI:' num2str(EIIncludedSorted1(i))];
    cfgOut = plotPialSurf(PatientID,cfg);
    set(gcf,'Position',[0 0 1920 1200])
    print(['Group-' num2str(CategorizationSorted(i)),'-', PatientID '-Recording-' ChannelIncludedSorted1{i}],'-r300','-dpng')
    
    close 
    
end
cd ..


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







