%% Path
clear
addpath(genpath('C:\Users\su_fe\Desktop\iELVis-master_BZ'))
%% Pamameters
clear
%%%%%%%%%%%%
PatientID = 'PT002';
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
    [startIndex,~] = regexp(ss(i).chan,'\S\d');
    ChannelIncluded{i,1} = ss(i).chan(startIndex(1) : startIndex(2) - 1);
    EIIncluded(i,1) = ss(i).EI;
    Categorization(i,1) = ss(i).tag;
end

%% %%%%%%% Plot the matrix %%%%%%%%%%%%%%

% Set NaNs to the matrix
for i = 1:length(EIIncluded)
    % Identify electrode in one electrode shaft
    ElectrodeShaftName = ChannelIncluded{i}(isletter(ChannelIncluded{i}));
    ConnectElectrodes = find(contains(ChannelIncluded,ElectrodeShaftName));
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

% 1st sort according to group
[CategorizationSorted, Index1] = sort(Categorization);
ChannelIncludedSorted1 = ChannelIncluded(Index1);
EIIncludedSorted1      = EIIncluded(Index1);
M_greySorted1          = M_grey(Index1,:);

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
ChannelsSorted.
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

% Plot the final sorted matrix
figure
imagesc(M_greySorted1,'AlphaData',~isnan(M_greySorted1))
colormap jet
grid on
xticks(1.5:size(M_greySorted1,1)+0.5)
yticks(1.5:size(M_greySorted1,2)+0.5)
ax = gca;
ax.LineWidth = 3
axis square
% Make the seperating line for each cell

% Make the seperating line for each group

%% %%%%%%%%%%%%% STIMULATION %%%%%%%%%%%%%%%%%%%%%%%

EvockedPotentials = [];
for i = 1:length(EIIncluded)
    
    ct1 = 0;
    % Identify electrode in one electrode shaft
    ElectrodeShaftName = ChannelIncluded{i}(isletter(ChannelIncluded{i}));
    ConnectElectrodes = find(~contains(ChannelIncluded,ElectrodeShaftName));
    for a = 1:length(ConnectElectrodes)
        ct1 = ct1 + 1;
        EvockedPotentials(ct1,i) = M_grey(i,ConnectElectrodes(a));
    end
end
figure
histogram(EvockedPotentials)
% M_grey = M_grey - min(EvockedPotentials);
% EvockedPotentials = EvockedPotentials - min(EvockedPotentials);

AbsMaxCCEP = max(EvockedPotentials(:));

mkdir('Stimulation')
cd('Stimulation')
for i = 1:length(EIIncluded)
    pairs=[];
    ct=0;
    % Identify electrode in one electrode shaft
    ElectrodeShaftName = ChannelIncluded{i}(isletter(ChannelIncluded{i}));
    ConnectElectrodes = find(~contains(ChannelIncluded,ElectrodeShaftName));
    for a = 1:length(ConnectElectrodes)
        ct = ct + 1;
        pairs{ct,1} = ChannelIncluded{i};
        pairs{ct,2} = ChannelIncluded{ConnectElectrodes(a)};
        pairs{ct,3} = [0.6 0.6 0.6]; % RGB val
        pairs{ct,4} = 'R';
        pairs{ct,6} = M_grey(i,ConnectElectrodes(a));
    end
    lineWidth = (max([pairs{:,6}])/AbsMaxCCEP) * 8;
    cfg = [];
    cfg.view = 'romni';
    cfg.figId = 2;
    cfg.lineWidth = lineWidth;
    cfg.pairs = pairs;
    % Color the electrodes according to EI value
    cfg.elecColors = EIIncluded;
    cfg.elecColorScale = [0 1];
    cfg.elecNames = ChannelIncluded;
    % 
    cfg.elecShape = 'marker';
    cfg.edgeBlack='n';
    cfg.ignoreDepthElec='n';
    cfg.ignoreChans = setdiff(groupLabelsRaw,ChannelIncluded);
    cfg.opaqueness=0.03;
    cfg.showLabels='n';
    cfg.elecUnits='EI';
    cfg.title= [PatientID '-Stimulating-' ChannelIncluded{i} '-Group-' num2str(Categorization(i))];
    cfgOut = plotPialSurf(PatientID,cfg);
    set(gcf,'Position',[0 0 1920 1200])
    print(['Group-' num2str(Categorization(i)),'-', PatientID '-Stimulating-' ChannelIncluded{i}],'-r300','-dpng')
    
    close 
    
end
cd ..

%% %%%%%%%%%%%%% RECORDING %%%%%%%%%%%%%%%%%%%%%%%
mkdir('Recording')
cd('Recording')
for i = 1:length(EIIncluded)
    pairs=[];
    ct=0;
    % Identify electrode in one electrode shaft
    ElectrodeShaftName = ChannelIncluded{i}(isletter(ChannelIncluded{i}));
    ConnectElectrodes = find(~contains(ChannelIncluded,ElectrodeShaftName));
    for a = 1:length(ConnectElectrodes)
        ct = ct + 1;
        pairs{ct,1} = ChannelIncluded{i};
        pairs{ct,2} = ChannelIncluded{ConnectElectrodes(a)};
        pairs{ct,3} = [0.6 0.6 0.6]; % RGB val
        pairs{ct,4} = 'R';
        pairs{ct,6} = M_grey(ConnectElectrodes(a),i);
    end
    lineWidth = (max([pairs{:,6}])/AbsMaxCCEP) * 8;
    cfg=[];
    cfg.view='romni';
    cfg.figId=2;
    cfg.lineWidth = lineWidth;
    cfg.pairs=pairs;
    % Color the electrodes according to EI value
    cfg.elecColors = EIIncluded;
    cfg.elecColorScale = [0 1];
    cfg.elecNames = ChannelIncluded;
    % 
    cfg.elecShape = 'marker';
    cfg.edgeBlack='n';
    cfg.ignoreDepthElec='n';
    cfg.ignoreChans = setdiff(groupLabelsRaw,ChannelIncluded);
    cfg.opaqueness=0.03;
    cfg.showLabels='n';
    cfg.elecUnits='EI';
    cfg.title= [PatientID '-Recording-' ChannelIncluded{i} '-Group-' num2str(Categorization(i))];
    cfgOut = plotPialSurf(PatientID,cfg);
    set(gcf,'Position',[0 0 1920 1200])
    print(['Group-' num2str(Categorization(i)),'-',PatientID '-Recording-' ChannelIncluded{i}],'-r300','-dpng')
    close 
    
end
cd ..

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







